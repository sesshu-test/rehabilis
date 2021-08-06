require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /index" do
    it "ユーザ一覧が表示される" do
      get "/users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    it "ログインしていれば他人のユーザ詳細にフォローボタンがある" do
      # ログインせずに他人のユーザ詳細に遷移
      get "/users/#{other_user.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include 'follow_form'
      # ログインして他人のユーザ詳細に遷移
      sign_in user
      get "/users/#{other_user.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).to include 'follow_form'
      # ログインして自分のユーザ詳細に遷移
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include 'follow_form'
    end
  end
end
