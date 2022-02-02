class Service < ApplicationRecord
  belongs_to :practitioner_specialty, optional: true
  has_many :sessions
  has_one :practitioner, through: :practitioner_specialty
  has_one :specialty, through: :practitioner_specialty
  has_many :service_health_goals, dependent: :destroy
  has_many :health_goals, through: :service_health_goals
  has_many :practitioner_languages, through: :practitioner
  has_many :languages, through: :practitioner_languages
  has_many :reviews, through: :sessions
  has_many :favorite_services, dependent: :destroy
  has_many :favorite_users, through: :favorite_services, source: :user
  has_many :service_promotions, dependent: :destroy
  has_many :user_promos, dependent: :destroy
  has_many :event_codes, dependent: :destroy
  has_many :need_services, dependent: :destroy
  has_many :offer_services, dependent: :destroy
  validates :name, presence: true
  validates :duration, presence: true
  validates :price, presence: true
  validates :description, presence: true, length: { minimum: 5, maximum: 2000 }
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
    (reviews.sum(:rating).to_f / reviews.size).round(2)
  end

  def self.active_services
    where(active: true, default_service: nil).joins(:practitioner).where(practitioners: { status: 'active' })
  end

  def matching_counts(array)
    goals = 0
    health_goals.each { |g| goals += 1 if g.id.in?(array) }
    goals
  end

  def last_promotion
    service_promotions.order('end_date DESC').first
  end

  def active_promotion?
    if last_promotion
      true if last_promotion.end_date > Time.current && last_promotion.start_date < Time.current
    end
  end
end
