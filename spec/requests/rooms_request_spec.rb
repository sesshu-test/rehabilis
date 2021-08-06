require 'rails_helper'

RSpec.describe "Rooms", type: :request do

  let(:user) { create(:user) }

  describe "GET /index" do
    it "ログインしていれば、DM一覧が表示される" do
      # ログインせずにDM一覧に遷移
      get "/rooms"
      expect(response).to redirect_to(new_user_session_path)
      # ログインしてDM一覧に遷移
      sign_in user
      get "/rooms"
      expect(response).to have_http_status(:success)
    end
  end

end
