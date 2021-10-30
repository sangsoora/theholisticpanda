class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_one :practitioner, dependent: :destroy
  has_many :user_health_goals, dependent: :destroy
  has_many :sessions
  has_many :favorite_practitioners, dependent: :destroy
  has_many :favorite_services, dependent: :destroy
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :conversations_as_recipient, foreign_key: :recipient_id, class_name: :Conversation, dependent: :destroy
  has_many :conversations_as_sender, foreign_key: :sender_id, class_name: :Conversation, dependent: :destroy
  has_many :health_goals, through: :user_health_goals
  has_many :payment_methods, dependent: :destroy
  has_many :user_promos, dependent: :destroy
  has_many :events
  has_one_attached :photo
  serialize :crop_setting

  validates :email, presence: true, format: { with: /.+@.+\..+/ }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 50 }
  validates :terms, presence: true, allow_nil: false
  validates :password,
    presence: true,
    length: { in: Devise.password_length },
    format: { with: PASSWORD_FORMAT },
    confirmation: true,
    on: :create
  validates :password,
    allow_nil: true,
    length: { in: Devise.password_length },
    format: { with: PASSWORD_FORMAT },
    confirmation: true,
    on: :update

  before_create :confirm_admin_without_confirmation_email
  after_create :subscribe_to_newsletter

  def confirm_admin_without_confirmation_email
    skip_confirmation! if admin
  end

  def after_confirmation
    UserMailer.with(user: self).welcome.deliver_now
    AdminMailer.with(user: self).new_user.deliver_now
    welcome_code = Stripe::PromotionCode.create({
      coupon: 'first_booking_discount',
      max_redemptions: 1,
      metadata: {
        user_id: id
      },
      restrictions: {
        minimum_amount: 5000,
        minimum_amount_currency: 'cad'
      }
    })
    UserPromo.create(name: 'WELCOMETOPANDA', detail: '10% off', user: self, promo_id: welcome_code.id, active: true, expires_at: Time.now + 3.months, coupon_id: 'first_booking_discount', type: 'coupon', discount_on: 'platform')
    @referred_user = ReferredUser.find_by(invited_user_id: id)
    if @referred_user
      new_user_code = Stripe::PromotionCode.create({
        coupon: 'referral_discount',
        max_redemptions: 1,
        metadata: {
          user_id: id
        },
        restrictions: {
          minimum_amount: 5000,
          minimum_amount_currency: 'cad'
        }
      })
      UserPromo.create(name: 'REFERRAL10', detail: '10% off', user: self, promo_id: new_user_code.id, active: true, expires_at: Time.now + 3.months, coupon_id: 'referral_discount', type: 'coupon', discount_on: 'platform')
      customer = @referred_user.user.stripe_id if @referred_user.user.stripe_id
      existing_user_code = Stripe::PromotionCode.create({
        coupon: 'referral_discount',
        customer: customer,
        max_redemptions: 1,
        metadata: {
          user_id: @referred_user.user.id
        },
        restrictions: {
          minimum_amount: 5000,
          minimum_amount_currency: 'cad'
        }
      })
      UserPromo.create(name: 'REFERRAL10', detail: '10% off', user: @referred_user.user, promo_id: existing_user_code.id, active: true, expires_at: Time.now + 3.months, coupon_id: 'referral_discount', type: 'coupon', discount_on: 'platform')
      ReferralMailer.with(user: self).new_user_coupon.deliver_now
      ReferralMailer.with(referred_user: @referred_user, user: self).existing_user_coupon.deliver_now
    end
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def cropped_image
    if photo.attached?
      if crop_setting?
        dimensions = "#{crop_setting[:w]}x#{crop_setting[:h]}"
        coord = "#{crop_setting[:x]}+#{crop_setting[:y]}"
        photo.variant(
          crop: "#{dimensions}+#{coord}"
        ).processed
      else
        photo
      end
    end
  end

  def conversations
    conversations_as_recipient.includes(:messages) + conversations_as_sender.includes(:messages)
  end

  def conversation_messages
    messages = []
    conversations_as_recipient.each do |c|
      c.messages.each { |m| messages << m }
    end
    conversations_as_sender.each do |c|
      c.messages.each { |m| messages << m }
    end
    messages
  end

  def last_conversation
    if conversation_messages == []
      conversations.last
    else
      conversation_messages.max_by(&:created_at).conversation
    end
  end

  def first_session?
    sessions.where(free_practitioner_id: nil).where.not(status: 'cancelled').count.zero?
  end

  private

  def subscribe_to_newsletter
    SubscribeToNewsletterService.new(self).call
  end
end
