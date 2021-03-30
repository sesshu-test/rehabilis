class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    @activities = current_user.active_notifications.page(params[:page])
  end

end
