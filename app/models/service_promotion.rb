class ServicePromotion < ApplicationRecord
  belongs_to :service

  validates_presence_of :start_date, :end_date, :discount_percentage
  validate :end_date_is_after_start_date

  private

  def end_date_is_after_start_date
    return if end_date.blank? || start_date.blank?

    if end_date < start_date
      errors.add(:end_date, "cannot be before the start date")
    end
  end
end
