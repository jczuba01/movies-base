require 'rails_helper'

RSpec.describe GenresController, type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user, scope: :user
  end

  describe "GET /genres" do
    it "returns a success response" do
      create(:genre)
      get genres_path
      expect(response).to be_successful
    end
  end

  describe "GET /genres/:id" do
    it "returns a success response" do
      genre = create(:genre)
      get genre_path(genre)
      expect(response).to be_successful
    end
  end

  describe "GET /genres/new" do
    it "returns a success response" do
      get new_genre_path
      expect(response).to be_successful
    end
  end

  describe "GET /genres/:id/edit" do
    it "returns a success response" do
      genre = create(:genre)
      get edit_genre_path(genre)
      expect(response).to be_successful
    end
  end

  describe "POST /genres" do
    context "with valid params" do
      it "creates a new Genre" do
        expect {
          post genres_path, params: { genre: attributes_for(:genre) }
        }.to change(Genre, :count).by(1)
      end

      it "redirects to the created genre" do
        post genres_path, params: { genre: attributes_for(:genre) }
        expect(response).to redirect_to(genre_path(Genre.last))
      end
    end

    context "with invalid params" do
      it "does not create a new Genre" do
        expect {
          post genres_path, params: { genre: attributes_for(:genre, name: nil) }
        }.to change(Genre, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post genres_path, params: { genre: attributes_for(:genre, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT /genres/:id" do
    context "with valid params" do
      it "updates the requested genre" do
        genre = create(:genre)
        new_attributes = attributes_for(:genre)
        patch genre_path(genre), params: { genre: new_attributes }
        genre.reload
        expect(genre.name).to eq(new_attributes[:name])
      end

      it "redirects to the genre" do
        genre = create(:genre)
        patch genre_path(genre), params: { genre: attributes_for(:genre) }
        expect(response).to redirect_to(genre_path(genre))
      end
    end

    context "with invalid params" do
      it "returns a unprocessable entity response" do
        genre = create(:genre)
        patch genre_path(genre), params: { genre: attributes_for(:genre, name: nil) }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /genres/:id" do
    it "destroys the requested genre" do
      genre = create(:genre)
      expect {
        delete genre_path(genre)
      }.to change(Genre, :count).by(-1)
    end

    it "redirects to the genres list" do
      genre = create(:genre)
      delete genre_path(genre)
      expect(response).to redirect_to(genres_path)
    end
  end
end