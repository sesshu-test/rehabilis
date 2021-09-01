class Ill < ApplicationRecord
  belongs_to :user
  validates :user, presence: true
  validates :name, length: {maximum: 25}
  MAX_ILLS_COUNT = 3
  validate :ills_count_must_be_within_limit

  private

  def ills_count_must_be_within_limit
    errors.add(:base, "ills count limit: #{MAX_ILLS_COUNT}") if user.ills.count >= MAX_ILLS_COUNT
  end
end
