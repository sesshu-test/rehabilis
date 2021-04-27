require 'rails_helper'

RSpec.describe "Posts", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    user = User.find_by(id: User.first.id)
    it "returns http success" do
      get "/posts/1"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include 'like_button'
      sign_in user
      get "/posts/1"
      expect(response.body).to include 'like_button'
    end
  end

end
