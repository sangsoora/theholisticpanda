class FavoriteService < ApplicationRecord
  belongs_to :user
  belongs_to :service
  validates_uniqueness_of :user, scope: [:service]
end
