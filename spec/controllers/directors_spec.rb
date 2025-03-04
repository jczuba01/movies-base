require 'rails_helper'

RSpec.describe DirectorsController, type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  describe "GET /directors" do
    it "returns a success response" do
      create(:director)
      get directors_path
      expect(response).to be_successful
    end
  end

  describe "GET /directors/:id" do
    it "returns a success response" do
      director = create(:director)
      get director_path(director)
      expect(response).to be_successful
    end
  end

  describe "GET /directors/new" do
    it "returns a success response" do
      get new_director_path
      expect(response).to be_successful
    end
  end

  describe "GET /directors/:id/edit" do
    it "returns a success response" do
      director = create(:director)
      get edit_director_path(director)
      expect(response).to be_successful
    end
  end

  describe "POST /directors" do
    context "with valid params" do
      it "creates a new Director" do
        expect {
          post directors_path, params: { director: attributes_for(:director) }
        }.to change(Director, :count).by(1)
      end

      it "redirects to the created director" do
        post directors_path, params: { director: attributes_for(:director) }
        expect(response).to redirect_to(director_path(Director.last))
      end
    end

    context "with invalid params" do
      it "does not create a new Director" do
        expect {
          post directors_path, params: { director: attributes_for(:director, first_name: nil) }
        }.to change(Director, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post directors_path, params: { director: attributes_for(:director, first_name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT /directors/:id" do
    context "with valid params" do
      it "updates the requested director" do
        director = create(:director)
        new_attributes = attributes_for(:director)
        patch director_path(director), params: { director: new_attributes }
        director.reload
        expect(director.first_name).to eq(new_attributes[:first_name])
        expect(director.last_name).to eq(new_attributes[:last_name])
        expect(director.birth_date).to eq(new_attributes[:birth_date])
      end

      it "redirects to the director" do
        director = create(:director)
        patch director_path(director), params: { director: attributes_for(:director) }
        expect(response).to redirect_to(director_path(director))
      end
    end

    context "with invalid params" do
      it "returns a unprocessable entity response" do
        director = create(:director)
        patch director_path(director), params: { director: attributes_for(:director, first_name: nil) }
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