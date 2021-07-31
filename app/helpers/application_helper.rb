module ApplicationHelper
  def display_avatar(user)
    if user.avatar.attached?
      user.avatar.variant(resize_to_limit: [50, 50])
    else
      "default-avatar.png"
    end
  end
end
