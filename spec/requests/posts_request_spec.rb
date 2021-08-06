require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:post) { FactoryBot.create(:post) }

  describe "GET /index" do
    it "投稿一覧が表示される" do
      get "/"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "ログインしていれば、投稿詳細ページにいいねボタンがある" do
      # ログインせずに投稿詳細に遷移
      get "/posts/#{post.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include 'like_button'
      # ログインして投稿詳細に遷移
      sign_in user
      get "/posts/#{post.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).to include 'like_button'
    end
  end

  describe "GET /new" do
    it "ログインしていれば、新規投稿ページのアクセスが成功" do
      # ログインせずに新規投稿に遷移
      get "/posts/new"
      expect(response).to redirect_to(new_user_session_path)
      # ログインして新規投稿に遷移
      sign_in user
      get "/posts/new"
      expect(response).to have_http_status(:success)
    end
  end

end
