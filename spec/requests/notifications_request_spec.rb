require 'rails_helper'

RSpec.describe "Notifications", type: :request do

  describe "GET /index" do
    let(:user) { create(:user) }
    it "ログインしていれば、通知一覧が表示される" do
      # ログインせずに通知一覧に遷移
      get "/notifications"
      expect(response).to redirect_to(new_user_session_path)
      # ログインして通知一覧に遷移
      sign_in user
      get "/notifications"
      expect(response).to have_http_status(:success)
    end
  end

end
