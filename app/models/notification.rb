class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true
  # allows notifications to connect to any other model, without having to
  # write belongs to for each

  scope :unread, ->{ where(read_at: nil) }

  def year
    self.created_at.strftime('%Y')
  end

  def month
    self.created_at.strftime('%b')
  end

  def day
    self.created_at.strftime('%d')
  end

  def hour
    self.created_at.strftime('%H')
  end

  def minute
    self.created_at.strftime('%M')
  end
end
