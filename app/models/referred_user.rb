class ReferredUser < ApplicationRecord
  belongs_to :user
  has_secure_token :invite_token
end
