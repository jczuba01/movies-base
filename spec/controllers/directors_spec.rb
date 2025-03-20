require 'rails_helper'

RSpec.describe DirectorsController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      create(:director)
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      director = create(:director)
      get :show, params: { id: director.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "GET #edit" do
    it "returns a success response" do
      director = create(:director)
      get :edit, params: { id: director.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Director" do
        expect {
          post :create, params: { director: attributes_for(:director) }
        }.to change(Director, :count).by(1)
      end

      it "redirects to the created director" do
        post :create, params: { director: attributes_for(:director) }
        expect(response).to redirect_to(director_path(Director.last))
      end
    end

    context "with invalid params" do
      it "does not create a new Director" do
        expect {
          post :create, params: { director: attributes_for(:director, first_name: nil) }
        }.to change(Director, :count).by(0)
      end

      it "returns an unprocessable entity response" do
        post :create, params: { director: attributes_for(:director, first_name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      it "updates the requested director" do
        director = create(:director)
        new_attributes = attributes_for(:director)
        patch :update, params: { id: director.id, director: new_attributes }
        director.reload
        expect(director.first_name).to eq(new_attributes[:first_name])
        expect(director.last_name).to eq(new_attributes[:last_name])
        expect(director.birth_date).to eq(new_attributes[:birth_date])
      end

      it "redirects to the director" do
        director = create(:director)
        patch :update, params: { id: director.id, director: attributes_for(:director) }
        expect(response).to redirect_to(director_path(director))
      end
    end

    context "with invalid params" do
      it "returns an unprocessable entity response" do
        director = create(:director)
        patch :update, params: { id: director.id, director: attributes_for(:director, first_name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested director" do
      director = create(:director)
      expect {
        delete :destroy, params: { id: director.id }
      }.to change(Director, :count).by(-1)
    end

    it "redirects to the directors list" do
      director = create(:director)
      delete :destroy, params: { id: director.id }
      expect(response).to redirect_to(directors_path)
    end
  end
end
