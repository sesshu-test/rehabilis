class SearchesController < ApplicationController
  def index
    @keyword = params[:keyword]
    @posts = Post.joins(:user, :rehabilitations).includes(:user, :rehabilitations).search_posts(@keyword).page(params[:page])
  end

  def icon_click
    @hashtags = Hashtag.joins(:post_hashtags).group(:hashtag_id).order('count(post_id) desc').includes(:posts).first(5)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def posts
    @keyword = params[:keyword]
    @posts = Post.joins(:user, :rehabilitations).includes(:user, :rehabilitations).search_posts(@keyword).page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def users
    @keyword = params[:keyword]
    @users = User.search_users(@keyword).page(params[:page])
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

end
