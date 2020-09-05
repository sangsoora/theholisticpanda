class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :practitioner, dependent: :destroy
  has_many :user_health_goals
  has_many :sessions
  has_many :favorite_practitioners
  has_many :favorite_services
  has_many :notifications, foreign_key: :recipient_id, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :conversations_as_recipient, foreign_key: :recipient_id, class_name: :Conversation, dependent: :destroy
  has_many :conversations_as_sender, foreign_key: :sender_id, class_name: :Conversation, dependent: :destroy

  validates :email, presence: true, format: { with: /.+@.+\..+/ }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :phone_number, format: { with: /\d+/ }

  def full_name
    return "#{first_name} #{last_name}"
  end

  def is_practitioner?
    self.practitioner
  end

  def conversations
    self.conversations_as_recipient + self.conversations_as_sender
  end

  def conversation_messages
    messages = []
    self.conversations_as_recipient.each do |c|
      c.messages.each do |m|
        messages << m
      end
    end
    self.conversations_as_sender.each do |c|
      c.messages.each do |m|
        messages << m
      end
    end
    messages
  end

  def last_conversation
    self.conversation_messages.max_by { |message| message.created_at }.conversation
  end
end
