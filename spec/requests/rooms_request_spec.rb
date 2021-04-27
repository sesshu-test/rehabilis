require 'rails_helper'

RSpec.describe "Rooms", type: :request do

  user = User.find_by(id: User.first.id)

  describe "GET /index" do
    it "returns http success" do
      sign_in user
      get "/rooms"
      expect(response).to have_http_status(:success)
    end
  end

end
