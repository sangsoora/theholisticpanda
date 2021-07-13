class PostCategory < ApplicationRecord
  has_many :post_sub_categories
  has_one_attached :banner

  def to_param
    name
  end
end
