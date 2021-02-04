class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  PASSWORD_FORMAT = /\A
    (?=.{8,})          # Must contain 8 or more characters
    (?=.*\d)           # Must contain a digit
    (?=.*[a-z])        # Must contain a lower case character
    (?=.*[A-Z])        # Must contain an upper case character
    (?=.*[[:^alnum:]]) # Must contain a symbol
  /x
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
  has_one_attached :photo

  validates :email, presence: true, format: { with: /.+@.+\..+/ }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }
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

  after_create :subscribe_newsletter

  def full_name
    "#{first_name} #{last_name}"
  end

  def is_practitioner?
    practitioner
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
    conversation_messages.max_by(&:created_at).conversation
  end

  private

  def send_welcome_email
    UserMailer.with(user: self).welcome.deliver_now
  end

  def subscribe_newsletter
    Newsletter.create(email: email) if newsletter && !Newsletter.find_by(email: email)
  end
end
