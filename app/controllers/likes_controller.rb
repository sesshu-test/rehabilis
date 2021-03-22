class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post

  def create
    @like = Like.create(user_id: current_user.id, post_id: params[:post_id])
    redirect_back(fallback_location: @post)
  end

  def destroy
    @like = Like.find_by(user_id: current_user.id, post_id: params[:post_id])
    @like.destroy
    redirect_back(fallback_location: @post)
  end

  private

    def set_post
      @post = Post.find(params[:post_id])
    end
end

