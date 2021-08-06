class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.includes(:visitor).page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def notification
    @notifications = current_user.passive_notifications.includes(:visitor).page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
    render 'index'
  end

  def activity
    @activities = current_user.active_notifications.includes(:visited).page(params[:page])
    render 'index'
  end

end
