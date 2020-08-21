class FavoritePractitioner < ApplicationRecord
  belongs_to :user
  belongs_to :practitioner
  validates_uniqueness_of :user, scope: [:practitioner]
end
