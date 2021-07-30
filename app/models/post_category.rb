class PostCategory < ApplicationRecord
  has_many :post_sub_categories
  has_many :posts, through: :post_sub_categories
  has_one_attached :banner
  has_one_attached :mobile_banner

  def to_param
    name.gsub(' ', '_')
  end
end
