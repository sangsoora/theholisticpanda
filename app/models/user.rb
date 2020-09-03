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
  has_many :chats_as_recipient, foreign_key: :recipient_id, class_name: :Chat, dependent: :destroy
  has_many :chats_as_sender, foreign_key: :sender_id, class_name: :Chat, dependent: :destroy

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

  def chats
    self.chats_as_recipient + self.chats_as_sender
  end
end
