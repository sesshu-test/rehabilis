require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  let(:user) { create(:user) }

  describe "GET /index" do
    it "ログインしていれば、通知一覧が表示される" do
      # ログインせずに通知一覧に遷移
      get "/notifications"
      expect(response).to redirect_to(new_user_session_path)
      # ログインして通知一覧に遷移
      sign_in user
      get "/notifications"
      expect(response).to have_http_status(:success)
      expect(response.body).not_to include '未読あり'
    end
  end
  it "未読の通知があれば表示があり、未読でなくなれば表示が消える" do
    # 通知の作成
    user2 = create(:user)
    post = create(:post)
    create(:notification, visited_id: user.id, visitor_id: user2.id, post_id: post.id, action: "like")
    # ログイン
    sign_in user
    # 投稿一覧に遷移した後では、未読の表示がある
    get "/"
    expect(response).to have_http_status(:success)
    expect(response.body).to include '未読あり'
    # 投稿一覧に遷移した後では、未読の表示がない
    get "/notifications"
    expect(response).to have_http_status(:success)
    expect(response.body).not_to include '未読あり'
  end

end
