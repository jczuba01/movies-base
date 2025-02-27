require 'rails_helper'

RSpec.describe "Genres", type: :request do  
  let(:valid_attributes) { attributes_for(:genre) }
  let(:invalid_attributes) { { name: "" } }

  describe "GET /genres" do
    it "returns a successful response" do
      get genres_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /genres/:id" do
    it "returns a successful response" do
      genre = create(:genre)
      get genre_path(genre)
      expect(response).to be_successful
    end
  end

  describe "GET /genres/new" do
    it "returns a successful response" do
      get new_genre_path
      expect(response).to be_successful
    end
  end

  describe "POST /genres" do
    context "with valid parameters" do
      it "creates a new Genre" do
        expect {
          post genres_path, params: { genre: valid_attributes }
        }.to change(Genre, :count).by(1)
      end

      it "redirects to the created genre" do
        post genres_path, params: { genre: valid_attributes }
        expect(response).to redirect_to(genre_path(Genre.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Genre" do
        expect {
          post genres_path, params: { genre: invalid_attributes }
        }.to change(Genre, :count).by(0)
      end

      it "returns an unprocessable entity status" do
        post genres_path, params: { genre: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /genres/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { name: "Updated Genre Name" } }

      it "updates the requested genre" do
        genre = create(:genre)
        patch genre_path(genre), params: { genre: new_attributes }
        genre.reload
        expect(genre.name).to eq("Updated Genre Name")
      end

      it "redirects to the genre" do
        genre = create(:genre)
        patch genre_path(genre), params: { genre: new_attributes }
        expect(response).to redirect_to(genre_path(genre))
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity status" do
        genre = create(:genre)
        patch genre_path(genre), params: { genre: invalid_attributes }
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