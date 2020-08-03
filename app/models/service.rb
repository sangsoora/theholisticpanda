class Service < ApplicationRecord
  belongs_to :practitioner_specialty
  has_many :sessions
  has_one :practitioner, through: :practitioner_specialty
  has_one :specialty, through: :practitioner_specialty
  has_many :specialty_conditions, through: :specialty
  has_many :conditions, through: :specialty_conditions
  has_many :practitioner_languages, through: :practitioner
  has_many :languages, through: :practitioner_languages
  monetize :price_cents
  scope :filter_by_specialty, ->(specialty) { joins(:specialty).where(specialties: { id: specialty }) }
  scope :filter_by_condition, ->(conditions) { joins(:conditions).where(conditions: { id: conditions }) }
  scope :filter_by_language, ->(languages) { joins(:languages).where(languages: { id: languages }) }
  scope :filter_by_service_type, ->(service_type) { where service_type: service_type }

  $specialties = Specialty.all.sort_by(&:name)
  $conditions = Condition.all.sort_by(&:name)
  $languages = Language.includes(:practitioner_languages).where.not(practitioner_languages: { id: nil }).sort_by(&:name)
  $types = ['Virtual', 'In-person']
end
