require 'rails_helper'

RSpec.describe "Movies", type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
  end
  
  let(:user) { create(:user) }
  let(:genre) { create(:genre) }
  let(:director) { create(:director) }
  let(:movie) { create(:movie) }
  let(:valid_attributes) { attributes_for(:movie).merge(genre_id: genre.id, director_id: director.id) }
  let(:invalid_attributes) { { title: "", description: "" } }
  let(:valid_review_attributes) { attributes_for(:review) }
  let(:invalid_review_attributes) { { rating: nil, comment: "" } }

  describe "GET /movies" do
    it "returns a successful response" do
      get movies_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /movies/:id" do
    it "returns a successful response" do
      get movie_path(movie)
      expect(response).to be_successful
    end

    it "includes movie reviews" do
      review = create(:review, movie: movie, user: user)
      get movie_path(movie)
      expect(response.body).to include(review.comment)
    end
  end

  describe "GET /movies/new" do
    it "returns a successful response" do
      get new_movie_path
      expect(response).to be_successful
    end
  end

  describe "GET /movies/:id/edit" do
    it "returns a successful response" do
      get edit_movie_path(movie)
      expect(response).to be_successful
    end
  end

  describe "POST /movies" do
    context "with valid parameters" do
      it "creates a new Movie" do
        expect {
          post movies_path, params: { movie: valid_attributes }
        }.to change(Movie, :count).by(1)
      end

      it "redirects to the created movie" do
        post movies_path, params: { movie: valid_attributes }
        expect(response).to redirect_to(movie_path(Movie.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Movie" do
        expect {
          post movies_path, params: { movie: invalid_attributes }
        }.not_to change(Movie, :count)
      end

      it "returns an unprocessable entity status" do
        post movies_path, params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /movies/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { title: "Updated Movie Title" } }

      it "updates the requested movie" do
        patch movie_path(movie), params: { movie: new_attributes }
        movie.reload
        expect(movie.title).to eq("Updated Movie Title")
      end

      it "redirects to the movie" do
        patch movie_path(movie), params: { movie: new_attributes }
        expect(response).to redirect_to(movie_path(movie))
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity status" do
        patch movie_path(movie), params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /movies/:id" do
    it "destroys the requested movie" do
      movie_to_delete = create(:movie)
      expect {
        delete movie_path(movie_to_delete)
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      delete movie_path(movie)
      expect(response).to redirect_to(movies_path)
    end
  end
end