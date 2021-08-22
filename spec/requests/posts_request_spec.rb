require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let(:user) { create(:user) }
  let(:post) { create(:post) }

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
    it "ログインしていれば、新規投稿のリンクがある" do
      get "/"
      # 新規投稿のリンクがない
      expect(response.body).not_to include 'new-post-button'
      # ログイン
      sign_in user
      # 新規投稿のリンクがある
      get "/"
      expect(response.body).to include 'new-post-button'
    end
  end

end
