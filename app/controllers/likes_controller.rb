class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    @like = Like.create(user_id: current_user.id, post_id: post.id)
    post.create_notification_like!(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    @like.destroy
    redirect_back(fallback_location: root_path)
  end

end

