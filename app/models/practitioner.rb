class Practitioner < ApplicationRecord
  belongs_to :user
  has_many :practitioner_languages, dependent: :destroy
  has_many :favorites, dependent: :destroy
end
