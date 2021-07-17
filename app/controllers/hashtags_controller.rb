class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.joins(:post_hashtags).group(:hashtag_id).order('count(post_id) desc').includes(:posts).page(params[:page])
  end
end
