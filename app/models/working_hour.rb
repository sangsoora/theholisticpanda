class WorkingHour < ApplicationRecord
  belongs_to :practitioner
  validates_presence_of :day
  validates_inclusion_of :day, in: 0..6

  # sample validation for better user feedback
  validates_uniqueness_of :opens, scope: [:practitioner, :day]
  validates_uniqueness_of :closes, scope: [:practitioner, :day]

  def day_of_week
    Date::ABBR_DAYNAMES[read_attribute(:day)]
  end

  def hours
    opening = opens.strftime('%H:%M') if opens
    closing = closes.strftime('%H:%M') if closes
    closing = '24:00' if closing == '00:00'
    opens ? "#{opening} ~ #{closing}" : 'N/A'
  end
end
