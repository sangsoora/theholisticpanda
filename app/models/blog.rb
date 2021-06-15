class Blog < ApplicationRecord
  belongs_to :blog_category
  has_one_attached :photo
end
