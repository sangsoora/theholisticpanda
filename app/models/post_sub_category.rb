class PostSubCategory < ApplicationRecord
  belongs_to :post_category
  has_many :posts
end
