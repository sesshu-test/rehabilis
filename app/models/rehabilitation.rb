class Rehabilitation < ApplicationRecord
  belongs_to :post
  has_one :user, through: :post
  validates :post, presence: true
  validates :name, presence: true, length: { maximum: 35 }
  validate :required_either_count_or_time

  private

    def required_either_count_or_time
      # 演算子 ^ で排他的論理和（XOR）にしています
      # countかtimeのどちらかの値があれば true
      # countとtimeどちらも入力されている場合や入力されていない場合は false
      return if count.present? ^ time.present?

      errors.add(:base, '回数または時間のどちらか一方を入力してください')
    end
end
