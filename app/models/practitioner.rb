class Practitioner < ApplicationRecord
  belongs_to :user
  has_many :practitioner_languages, dependent: :destroy
  has_many :practitioner_specialties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :services, through: :practitioner_specialties, dependent: :destroy
  has_many :sessions, through: :services
  has_many :languages, through: :practitioner_languages
  has_many :specialties, through: :practitioner_specialties
end
