class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.joins(:post_hashtag).group(:hashtag_id).order('count(post_id) desc').page(params[:page])
  end
end
