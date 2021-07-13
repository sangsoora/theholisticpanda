class Post < ApplicationRecord
  belongs_to :post_sub_category
  has_one_attached :photo

  def to_param
    short_title
  end
end
