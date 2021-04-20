class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room
  before_action :get_all_messages
  
  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      message.create_notification_message!(current_user)
      respond_to do |format|
        #format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    respond_to do |format|
      #format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  private

    def message_params
      params.require(:message).permit(:room_id, :content)
    end

    def set_room
      @room = Room.find(params[:message][:room_id])
    end

    def get_all_messages
      @messages = @room.messages.includes(:user)
    end
end
