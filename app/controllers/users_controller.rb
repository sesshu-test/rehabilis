class UsersController < ApplicationController
  before_action :set_user, only: [:show, :following, :followers]
  before_action :join_room, only: :show

  def show
    likes = Like.where(user_id: @user.id).order(created_at: :desc).pluck(:post_id)
    @likes = Post.find(likes)
  end

  def index
    @users = User.all.page(params[:page])
  end

  def following
    @title = "Following"
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def join_room
    if user_signed_in?
      unless @user.id == current_user.id
        # Entryモデルからロレコードを抽出
        @current_entry = Entry.where(user_id: current_user.id)
        @another_entry = Entry.where(user_id: @user.id)
        @current_entry.each do |current|
          @another_entry.each do |another|
            # ルームが存在する場合
            if current.room_id == another.room_id
              @is_room = true
              @room_id = current.room_id
            end
          end
        end
        # ルームが存在しない場合は新規作成
        unless @is_room
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

end
