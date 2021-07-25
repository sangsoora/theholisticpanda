class Post < ApplicationRecord
  belongs_to :post_sub_category
  belongs_to :post_author
  delegate :post_category, to: :post_sub_category, allow_nil: true
  has_one_attached :photo

  def to_param
    short_title
  end
end
