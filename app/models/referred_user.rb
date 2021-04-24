class ReferredUser < ApplicationRecord
  belongs_to :user
  has_secure_token :invite_token

  validates :email, presence: true, format: { with: /.+@.+\..+/ }
  validates_uniqueness_of :email, message: ' has been invited already'
end
