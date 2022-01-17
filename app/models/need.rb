class Need < ApplicationRecord
  has_many :need_services, dependent: :destroy
  has_one_attached :photo
end
