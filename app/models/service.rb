class Service < ApplicationRecord
  belongs_to :practitioner_specialty
  has_many :sessions
  has_one :practitioner, through: :practitioner_specialty
  has_one :specialty, through: :practitioner_specialty
  has_many :service_health_goals
  has_many :health_goals, through: :service_health_goals
  has_many :practitioner_languages, through: :practitioner
  has_many :languages, through: :practitioner_languages
  has_many :reviews, through: :sessions
  has_many :favorite_services, dependent: :destroy
  has_many :favorite_users, through: :favorite_services, source: :user
  validates :name, presence: true
  validates :duration, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :service_type, presence: true
  monetize :price_cents
  scope :filter_by_specialty, ->(specialty) { joins(:specialty).where(specialties: { id: specialty }) }
  scope :filter_by_health_goal, ->(health_goals) { joins(:health_goals).where(health_goals: { id: health_goals }) }
  scope :filter_by_language, ->(languages) { joins(:languages).where(languages: { id: languages }) }
  scope :filter_by_service_type, ->(service_type) { where service_type: service_type }

  $specialties = Specialty.all.sort_by(&:name)
  $health_goals = HealthGoal.all.sort_by(&:name)
  $languages = Language.includes(:practitioner_languages).where.not(practitioner_languages: { id: nil }).sort_by(&:name)
  $types = ['Virtual', 'In-person']

  def rating_avg
    (self.reviews.sum(:rating).to_f / self.reviews.size).round(2)
  end
end
