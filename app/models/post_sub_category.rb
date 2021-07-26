class PostSubCategory < ApplicationRecord
  belongs_to :post_category
  has_many :posts

  def to_param
    name.gsub(' ', '_')
  end
end
