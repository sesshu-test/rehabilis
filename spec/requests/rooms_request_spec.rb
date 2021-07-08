require 'rails_helper'

RSpec.describe "Rooms", type: :request do

  let(:user) { FactoryBot.create(:user) }

  describe "GET /index" do
    it "returns http success" do
      sign_in user
      get "/rooms"
      expect(response).to have_http_status(:success)
    end
  end

end
