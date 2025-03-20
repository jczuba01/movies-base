require 'rails_helper'

RSpec.describe GenresController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      create(:genre)
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      genre = create(:genre)
      get :show, params: { id: genre.id }
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
      genre = create(:genre)
      get :edit, params: { id: genre.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Genre" do
        expect {
          post :create, params: { genre: attributes_for(:genre) }
        }.to change(Genre, :count).by(1)
      end

      it "redirects to the created genre" do
        post :create, params: { genre: attributes_for(:genre) }
        expect(response).to redirect_to(genre_path(Genre.last))
      end
    end

    context "with invalid params" do
      it "does not create a new Genre" do
        expect {
          post :create, params: { genre: attributes_for(:genre, name: nil) }
        }.to change(Genre, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post :create, params: { genre: attributes_for(:genre, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      it "updates the requested genre" do
        genre = create(:genre)
        new_attributes = attributes_for(:genre)
        patch :update, params: { id: genre.id, genre: new_attributes }
        genre.reload
        expect(genre.name).to eq(new_attributes[:name])
      end

      it "redirects to the genre" do
        genre = create(:genre)
        patch :update, params: { id: genre.id, genre: attributes_for(:genre) }
        expect(response).to redirect_to(genre_path(genre))
      end
    end

    context "with invalid params" do
      it "returns a unprocessable entity response" do
        genre = create(:genre)
        patch :update, params: { id: genre.id, genre: attributes_for(:genre, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested genre" do
      genre = create(:genre)
      expect {
        delete :destroy, params: { id: genre.id }
      }.to change(Genre, :count).by(-1)
    end

    it "redirects to the genres list" do
      genre = create(:genre)
      delete :destroy, params: { id: genre.id }
      expect(response).to redirect_to(genres_path)
    end
  end
end
