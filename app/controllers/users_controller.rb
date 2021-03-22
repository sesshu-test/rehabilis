class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    likes = Like.where(user_id: current_user.id).order(created_at: :desc).pluck(:post_id)
    @likes = Post.find(likes)
  end

  def index
    @users = User.all.page(params[:page])
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.page(params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.page(params[:page])
    render 'show_follow'
  end

end
