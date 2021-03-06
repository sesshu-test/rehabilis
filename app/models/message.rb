class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy
  validates :content, presence: true, length: { maximum: 1000 }

  def create_notification_message!(current_user)
    temp = Notification.where(["visitor_id = ? and message_id = ? and action = ? ", current_user.id, id, 'message'])
    if temp.blank?
      temp_ids = Entry.select(:user_id).where(room_id: room_id).where.not(user_id: current_user.id).distinct
      temp_ids.each do |temp_id|
        notification = current_user.active_notifications.new(
          visited_id: temp_id['user_id'],
          visitor_id: current_user.id,
          message_id: id,
          action: 'message'
        )
        if notification.visitor_id == notification.visited_id
          notification.checked = true
        end
        notification.save if notification.valid?
      end
    end
  end
end
