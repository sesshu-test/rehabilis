require 'rails_helper'

RSpec.describe "Notifications", type: :request do

  describe "GET /index" do
    let(:user) { FactoryBot.create(:user) }
    it "returns http success" do
      sign_in user
      get "/notifications"
      expect(response).to have_http_status(:success)
    end
  end

end
