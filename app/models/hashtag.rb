class Hashtag < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }
  has_many :post_hashtag, dependent: :destroy
  has_many :post, through: :post_hashtag
end
