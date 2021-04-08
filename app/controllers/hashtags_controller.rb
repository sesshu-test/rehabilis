class HashtagsController < ApplicationController
  def index
    @hashtags = Hashtag.all.page(params[:page])
  end
end
