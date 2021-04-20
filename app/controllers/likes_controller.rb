class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:id])
    @like = Like.create(user_id: current_user.id, post_id: @post.id)
    @post.create_notification_like!(current_user)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @like = Like.find_by(user_id: current_user.id, post_id: params[:id])
    @like.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

end

