class User < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable
  has_one_attached :avatar
  has_many :posts, dependent: :destroy
  has_many :likes
  has_many :ills, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                  foreign_key: "followed_id",
                                  dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy
  validates :name, presence: true
  validates :avatar,   content_type: { in: %w[image/jpeg image/gif image/png], message: "must be a valid image format" },
                      size:         { less_than: 5.megabytes, message: "should be less than 5MB" }
  scope :search_users, ->(keyword) do
    where("name LIKE ?", "%#{keyword}%")
  end
  scope :users_with_like_ill, ->(user) do
    ill_names = []
    user.ills.each_with_index do |ill, i| 
      unless ill.name == nil
        ill_names << ill.name
      end
    end
    if ill_names.length == 1
      where("ills.name LIKE ?", "%#{ill_names[0]}%")
    elsif ill_names.length == 2
      where("ills.name LIKE ?", "%#{ill_names[0]}%").
        or(where("ills.name LIKE ?", "%#{ill_names[1]}%"))
    elsif ill_names.length == 3
      where("ills.name LIKE ?", "%#{ill_names[0]}%").
        or(where("ills.name LIKE ?", "%#{ill_names[1]}%")).
          or(where("ills.name LIKE ?", "%#{ill_names[2]}%"))
    end
  end

  # ユーザーをフォローする
  def follow(other_user)
    following << other_user
  end

  # ユーザーをフォロー解除する
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # 現在のユーザーがフォローしてたらtrueを返す
  def following?(other_user)
    following.include?(other_user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

end
