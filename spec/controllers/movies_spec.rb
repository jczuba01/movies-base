require 'rails_helper'

RSpec.describe MoviesController, type: :controller do
  let(:user) { create(:user) }
  let(:genre) { create(:genre) }
  let(:director) { create(:director) }
  let(:valid_attributes) {
    attributes_for(:movie).merge(genre_id: genre.id, director_id: director.id)
  }
  let(:invalid_attributes) {
    attributes_for(:movie, title: nil)
  }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      create(:movie, genre: genre, director: director)
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      movie = create(:movie, genre: genre, director: director)
      get :show, params: { id: movie.id }
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
      movie = create(:movie, genre: genre, director: director)
      get :edit, params: { id: movie.id }
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Movie" do
        expect {
          post :create, params: { movie: valid_attributes }
        }.to change(Movie, :count).by(1)
      end

      it "redirects to the created movie" do
        post :create, params: { movie: valid_attributes }
        expect(response).to redirect_to(movie_path(Movie.last))
      end
    end

    context "with invalid params" do
      it "does not create a new Movie" do
        expect {
          post :create, params: { movie: invalid_attributes }
        }.to change(Movie, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post :create, params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Updated Title", description: "Updated Description" }
      }

      it "updates the requested movie" do
        movie = create(:movie, genre: genre, director: director)
        patch :update, params: { id: movie.id, movie: new_attributes }
        movie.reload
        expect(movie.title).to eq("Updated Title")
        expect(movie.description).to eq("Updated Description")
      end

      it "redirects to the movie" do
        movie = create(:movie, genre: genre, director: director)
        patch :update, params: { id: movie.id, movie: valid_attributes }
        expect(response).to redirect_to(movie_path(movie))
      end
    end

    context "with invalid params" do
      it "returns a unprocessable entity response" do
        movie = create(:movie, genre: genre, director: director)
        patch :update, params: { id: movie.id, movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested movie" do
      movie = create(:movie, genre: genre, director: director)
      expect {
        delete :destroy, params: { id: movie.id }
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      movie = create(:movie, genre: genre, director: director)
      delete :destroy, params: { id: movie.id }
      expect(response).to redirect_to(movies_path)
    end
  end
end