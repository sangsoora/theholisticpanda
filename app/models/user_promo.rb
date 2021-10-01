class UserPromo < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :service, optional: true
end
