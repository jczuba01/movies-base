require 'rails_helper'

RSpec.describe "Roles", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/roles/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /destroy" do
    it "returns http success" do
      get "/roles/destroy"
      expect(response).to have_http_status(:success)
    end
  end

end
