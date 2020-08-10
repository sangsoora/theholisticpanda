class Practitioner < ApplicationRecord
  belongs_to :user
  has_one_attached :photo
  has_many :practitioner_languages, dependent: :destroy
  has_many :practitioner_specialties, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :services, through: :practitioner_specialties, dependent: :destroy
  has_many :sessions, through: :services
  has_many :languages, through: :practitioner_languages
  has_many :specialties, through: :practitioner_specialties
  has_many :health_goals, through: :specialties
  validates_uniqueness_of :user
  scope :filter_by_specialty, ->(specialties) { joins(:specialties).where(specialties: { id: specialties }) }
  scope :filter_by_health_goal, ->(health_goals) { joins(:health_goals).where(health_goals: { id: health_goals }) }
  scope :filter_by_language, ->(languages) { joins(:languages).where(languages: { id: languages }) }
  scope :filter_by_service_type, ->(service_type) { where service_type: service_type }

  $specialties = Specialty.all.sort_by(&:name)
  $health_goals = HealthGoal.all.sort_by(&:name)
  $languages = Language.includes(:practitioner_languages).where.not(practitioner_languages: { id: nil }).sort_by(&:name)
  $service_types = ['Virtual only', 'In-person only', 'Both availble']
end
