class Post < ApplicationRecord
  belongs_to :post_category
  has_one_attached :photo

  def to_param
    short_title
  end
end
