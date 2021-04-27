require 'rails_helper'

RSpec.describe "Users", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/users"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    user = User.find_by(id: User.first.id)
    it "returns http success" do
      get "/users/#{user.id}"
      expect(response).to have_http_status(:success)
    end
  end

end
