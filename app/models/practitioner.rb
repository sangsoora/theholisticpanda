class Practitioner < ApplicationRecord
  belongs_to :user
  has_many :practitioner_languages, dependent: :destroy
  has_many :practitioner_specialties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :services, through: :practitioner_specialties, dependent: :destroy
  has_many :sessions, through: :services
  has_many :languages, through: :practitioner_languages
  has_many :specialties, through: :practitioner_specialties
  scope :filter_by_education, ->(education) { where education: education }
  scope :filter_by_specialty, ->(specialties) { joins(:specialties).where(specialties: { id: specialties }) }
  scope :filter_by_condition, ->(education) { where education: education }
  scope :filter_by_language, ->(education) { where education: education }

  $educations = Practitioner.all.sort_by(&:education).map(&:education)
  $specialties = Specialty.all.sort_by(&:name)
  $conditions = Condition.all.sort_by(&:name)
  $languages = Language.includes(:practitioner_languages).where.not(practitioner_languages: { id: nil }).sort_by(&:language).map(&:language)
end
