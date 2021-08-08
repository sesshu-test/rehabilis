class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  before_action :correct_user,   only: :destroy

  def index
    @hashtags = Hashtag.joins(:post_hashtags).group(:hashtag_id).order('count(post_id) desc').includes(:posts).first(5)
    if params[:name]
      @category = params[:name]
      if @category == 'timeline' && user_signed_in?
        user_ids = current_user.following.pluck(:id) << current_user.id
        @posts = Post.where(user_id: user_ids).includes(:user).page(params[:page])
      #全ユーザの投稿一覧
      elsif @category == 'all'
        @posts = Post.includes(:user).page(params[:page])
      #選択されたハッシュタグの投稿一覧
      else
        @hashtag = Hashtag.find_by(name: params[:name])
        @posts = @hashtag.posts.includes(:user).page(params[:page])
        if params[:from_hashtag] == 'true'
          redirect_to root_path && return
        end
      end
      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    else
      @posts = Post.includes(:user).page(params[:page])
    end
  end

  def show
    @post = Post.find(params[:id])
    @likes = Like.where(post_id: @post.id) 
    @comments = @post.comments.includes(:user)
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @count_number = 0
    @time_number = 0
  end

  def new_rehabilitation
    if params[:count] == "plus"
      @count_number = params[:count_number].to_i + 1
      @time_number = params[:time_number].to_i
    elsif params[:count] == "minus"
      @count_number = params[:count_number].to_i - 1
      @time_number = params[:time_number].to_i
    elsif params[:time] == "plus"
      @count_number = params[:count_number].to_i
      @time_number = params[:time_number].to_i + 1
    elsif params[:time] == "minus"
      @count_number = params[:count_number].to_i
      @time_number = params[:time_number].to_i - 1
    end
    render 'new'
  end

  def create
    @post = current_user.posts.build(post_params)
    #create_hashtags
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
      params.permit(:impression, images: [])
    end

    def create_hashtags
      hashtags  = @post.impression.scan(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/)
      hashtags.uniq.map do |h|
        @post.impression.slice!(h)
        hashtag = Hashtag.find_or_create_by(name: h.downcase.delete('#'))
        @post.hashtags << hashtag
      end
    end

    def create_rehabilitations
      if params[:rehabilitations].keys.length <= 10
        params[:rehabilitations].keys.each do |key|
          @post.rehabilitations.create(params.require("rehabilitations").require(key).permit(:name, :time, :count))
        end
      end
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
