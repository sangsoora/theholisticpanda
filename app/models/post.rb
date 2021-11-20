class Post < ApplicationRecord
  belongs_to :post_sub_category
  belongs_to :post_author
  delegate :post_category, to: :post_sub_category, allow_nil: true
  has_one_attached :photo

  validates :title, presence: true
  validates :short_title, presence: true
  validates :body, presence: true

  def to_param
    short_title
  end
end
