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

  $tax_types_value = ['ca_bn', 'ca_qst', 'ae_trn', 'au_abn', 'br_cnpj', 'br_cpf', 'ch_vat', 'cl_tin', 'es_cif', 'eu_vat', 'gb_vat', 'hk_br', 'id_npwp', 'in_gst', 'jp_cn', 'jp_rn', 'kr_brn', 'li_uid', 'mx_rfc', 'my_frp', 'my_itn', 'my_sst', 'no_vat', 'nz_gst', 'ru_inn', 'ru_kpp', 'sa_vat', 'sg_gst', 'sg_uen', 'th_vat', 'tw_vat', 'us_ein', 'za_vat']
  $tax_types_name = ['Canadian BN', 'Canadian QST number', 'United Arab Emirates TRN', 'Australian Business Number (AU ABN)', 'Brazilian CNPJ number', 'Brazilian CPF number', 'Switzerland VAT number', 'Chilean TIN', 'Spanish CIF number', 'European VAT number', 'United Kingdom VAT number', 'Hong Kong BR number', 'Indonesian NPWP number', 'Indian GST number', 'Japanese Corporate Number', 'Japanese Foreign Business Registration Number', 'Korean BRN', 'Liechtensteinian UID number', 'Mexican RFC number', 'Malaysian FRP number', 'Malaysian ITN', 'Malaysian SST number', 'Norwegian VAT number', 'New Zealand GST number', 'Russian INN', 'Russian KPP', 'Saudi Arabia VAT', 'Singaporean GST', 'Singaporean UEN', 'Thai VAT', 'Taiwanese VAT', 'United States EIN', 'South African VAT number']
  $eu_countries = ['Austria', 'Belgium', 'Bulgaria', 'Cyprus', 'Czech Republic', 'Germany', 'Denmark', 'Estonia', 'Spain', 'Finland', 'France', 'Greece', 'Croatia', 'Hungary', 'Ireland', 'Italy', 'Lithuania', 'Luxembourg', 'Latvia', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Sweden', 'Slovenia', 'Slovakia', 'Northern Ireland']

  before_create :confirm_admin_without_confirmation_email
  after_create :subscribe_to_newsletter

  def confirm_admin_without_confirmation_email
    skip_confirmation! if admin
  end

  def after_confirmation
    UserMailer.with(user: self).welcome.deliver_now
    AdminMailer.with(user: self).new_user.deliver_now
    @referred_user = ReferredUser.find_by(invited_user_id: id)
    if @referred_user
      new_user_code = Stripe::PromotionCode.create({
        coupon: 'referral_discount',
        expires_at: (Time.now + 3.months).to_i,
        max_redemptions: 1,
        metadata: {
          user_id: id
        }
      })
      UserPromo.create(name: 'REFERRAL10', user: self, promo_id: new_user_code.id, active: true, expires_at: Time.at(new_user_code.expires_at).to_datetime)
      customer = @referred_user.user.stripe_id if @referred_user.user.stripe_id
      existing_user_code = Stripe::PromotionCode.create({
        coupon: 'referral_discount',
        expires_at: (Time.now + 3.months).to_i,
        customer: customer,
        max_redemptions: 1,
        metadata: {
          user_id: @referred_user.user.id
        }
      })
      UserPromo.create(name: 'REFERRAL10', user: @referred_user.user, promo_id: existing_user_code.id, active: true, expires_at: Time.at(existing_user_code.expires_at).to_datetime)
      ReferralMailer.with(user: self).new_user_coupon.deliver_now
      ReferralMailer.with(referred_user: @referred_user, user: self).existing_user_coupon.deliver_now
    end
    welcome_code = Stripe::PromotionCode.create({
      coupon: 'first_booking_discount',
      expires_at: (Time.now + 3.months).to_i,
      max_redemptions: 1,
      metadata: {
        user_id: id
      }
    })
    UserPromo.create(name: 'WELCOMETOPANDA', user: self, promo_id: welcome_code.id, active: true, expires_at: Time.at(welcome_code.expires_at).to_datetime)
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

  private

  def subscribe_to_newsletter
    SubscribeToNewsletterService.new(self).call
  end
end
