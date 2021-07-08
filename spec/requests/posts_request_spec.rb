require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  describe "GET /index" do
    it "returns http success" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "ログインしていれば、投稿詳細ページにいいねボタンがある" do
      get "/posts/#{post.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include 'like_button'
      sign_in user
      get "/posts/#{post.id}"
      expect(response.body).to include 'like_button'
    end
  end

  describe "GET /new" do
    it "ログインしていれば、新規投稿ページのアクセスが成功" do
      get "/posts/new"
      expect(response).to redirect_to "/users/sign_in"
      sign_in user
      get "/posts/new"
      expect(response).to have_http_status(:success)
    end
  end

end
