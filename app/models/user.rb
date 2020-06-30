class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :practitioner, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :email, presence: true, format: { with: /.+@.+\..+/ }
  validates :first_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :last_name, presence: true, length: { minimum: 2, maximum: 20 }
  validates :phone_number, format: { with: /\d+/ }

  def full_name
    return "#{first_name} #{last_name}"
  end
end
