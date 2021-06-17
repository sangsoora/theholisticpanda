class PostCategory < ApplicationRecord
  has_many :posts

  def to_param
    name
  end
end
