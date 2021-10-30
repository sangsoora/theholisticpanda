class EventCode < ApplicationRecord
  belongs_to :service, optional: true
  belongs_to :practitioner, optional: true
  belongs_to :event
end
