class Newsletter < ApplicationRecord
  validates :email, presence: true, format: { with: /.+@.+\..+/ }, uniqueness: true
end
