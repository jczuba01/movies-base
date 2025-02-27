require 'rails_helper'

RSpec.describe "Directors", type: :request do
  let(:valid_attributes) { attributes_for(:director) }
  let(:invalid_attributes) { { first_name: "", last_name: "" } }

  describe "GET /directors" do
    it "returns a successful response" do
      get directors_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /directors/:id" do
    it "returns a successful response" do
      director = create(:director)
      get director_path(director)
      expect(response).to be_successful
    end
  end

  describe "GET /directors/new" do
    it "returns a successful response" do
      get new_director_path
      expect(response).to be_successful
    end
  end

  describe "POST /directors" do
    context "with valid parameters" do
      it "creates a new Director" do
        expect {
          post directors_path, params: { director: valid_attributes }
        }.to change(Director, :count).by(1)
      end

      it "redirects to the created director" do
        post directors_path, params: { director: valid_attributes }
        expect(response).to redirect_to(director_path(Director.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Director" do
        expect {
          post directors_path, params: { director: invalid_attributes }
        }.to change(Director, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post directors_path, params: { director: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /directors/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { first_name: "Updated Name" } }

      it "updates the requested director" do
        director = create(:director)
        patch director_path(director), params: { director: new_attributes }
        director.reload
        expect(director.first_name).to eq("Updated Name")
      end

      it "redirects to the director" do
        director = create(:director)
        patch director_path(director), params: { director: new_attributes }
        expect(response).to redirect_to(director_path(director))
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity status" do
        director = create(:director)
        patch director_path(director), params: { director: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /directors/:id" do
    it "destroys the requested director" do
      director = create(:director)
      expect {
        delete director_path(director)
      }.to change(Director, :count).by(-1)
    end

    it "redirects to the directors list" do
      director = create(:director)
      delete director_path(director)
      expect(response).to redirect_to(directors_path)
    end
  end
end