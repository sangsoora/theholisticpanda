class Notification < ApplicationRecord
  belongs_to :recipient, class_name: "User"
  belongs_to :actor, class_name: "User"
  belongs_to :notifiable, polymorphic: true
  # allows notifications to connect to any other model, without having to
  # write belongs to for each

  scope :unread, ->{ where(read_at: nil) }
end
