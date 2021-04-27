class Hashtag < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  has_many :post_hashtags, dependent: :destroy
  has_many :posts, through: :post_hashtags
end
