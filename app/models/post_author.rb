class PostAuthor < ApplicationRecord
  belongs_to :practitioner, optional: true
  has_many :posts
  has_one_attached :photo

  def full_name
    "#{first_name} #{last_name}"
  end
end
