class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @posts = Post.all.page(params[:page])
  end

  def show
    @post = Post.find(params[:id])
    @likes = Like.where(post_id: @post.id) 
    @comments = @post.comments
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    rehabilitation = @post.rehabilitation.build(rehabilitation_params)
    if @post.save
      rehabilitation.save
      flash[:success] = "post created!"
      redirect_to root_url
    else
      render 'posts/new'
    end
  end

  def destroy
    @post.destroy
    redirect_to root_url
  end

  private

    def post_params
      params.require(:post).permit(:impression)
    end

    def rehabilitation_params
      params.require(:post).permit(:name, :time, :count)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id], post_id: params[:post_id])
      debugger
      redirect_to root_url if @post.nil?
    end
end
