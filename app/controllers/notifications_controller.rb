class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.where.not(visitor_id: current_user.id).includes(:visitor).page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def notification
    @notifications = current_user.passive_notifications.where.not(visitor_id: current_user.id).includes(:visitor).page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def activity
    @activities = current_user.active_notifications.includes(:visited).page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

end
