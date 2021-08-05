class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user,   only: :destroy
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      @post.create_notification_comment!(current_user, @comment.id)
      flash[:success] = "コメントしました"
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      flash[:success] = "コメントできませんでした"
      redirect_back(fallback_location: root_path)
    end
    get_all_comments
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
    get_all_comments
  end

  private
    def comment_params
      params.require(:comment).permit(:content)
    end

    def correct_user
      @comment = current_user.comments.find_by(id: params[:id])
      redirect_to root_url if @comment.nil?
    end

    def set_post
      @post = Post.find(params[:post_id])
    end

    def get_all_comments
      @comments = @post.comments.includes(:user)
    end
end
