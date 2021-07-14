class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @posts = Post.all.page(params[:page])
  end

  def search
    @posts = Post.joins(:user, :rehabilitations).search(params[:keyword]).page(params[:page])
    @keyword = params[:keyword]
    render "index"
  end

  def hashtag
    @hashtag = Hashtag.find_by(name: params[:name])
    @posts = @hashtag.posts.page(params[:page])
    render 'posts/index'
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
    if @post.save
      create_rehabilitations
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

    def create_rehabilitations
      0.upto(params[:post][:number].to_i){|num|
        @post.rehabilitations.create(params.require("rehabilitation_#{num}").permit(:name, :time, :count))
      }
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
