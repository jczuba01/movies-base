require 'rails_helper'

RSpec.describe "Api::V1::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:genre) { create(:genre) }
  let(:director) { create(:director) }
  let(:movie) { create(:movie, genre: genre, director: director) }

  let(:valid_attributes) {
    attributes_for(:review).merge(user_id: user.id)
  }

  let(:invalid_attributes) {
    attributes_for(:review, rating: nil, comment: nil).merge(user_id: user.id)
  }

  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /api/v1/movies/:movie_id/reviews" do
    it "returns a success response" do
      review = create(:review, movie: movie, user: user)
      get api_v1_movie_reviews_path(movie), headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(JSON.parse(review.to_json))
    end
  end

  describe "GET /api/v1/movies/:movie_id/reviews/:id" do
    it "returns a success response" do
      review = create(:review, movie: movie, user: user)
      get api_v1_movie_review_path(movie, review), headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(review.to_json))
    end
  end

  describe "POST /api/v1/movies/:movie_id/reviews" do
    context "with valid params" do
      it "creates a new Review" do
        expect {
          post api_v1_movie_reviews_path(movie), params: { review: valid_attributes }, headers: headers
        }.to change(Review, :count).by(1)
      end

      it "renders a JSON response with the new review" do
        allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)

        post api_v1_movie_reviews_path(movie), params: { review: valid_attributes }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')

        response_body = JSON.parse(response.body)
        puts "Review from API response: #{response_body.inspect}"

        expect(UpdateMovieRatingJob).to have_received(:perform_async).with(movie.id)

        expect(response_body["rating"]).to eq(valid_attributes[:rating])
        expect(response_body["comment"]).to eq(valid_attributes[:comment])
        expect(response_body["user_id"]).to eq(user.id)
        expect(response_body["movie_id"]).to eq(movie.id)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new review" do
        post api_v1_movie_reviews_path(movie), params: { review: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "PUT /api/v1/movies/:movie_id/reviews/:id" do
    context "with valid params" do
      let(:new_attributes) {
        attributes_for(:review)
      }

      it "updates the requested review" do
        allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)

        review = create(:review, movie: movie, user: user)
        put api_v1_movie_review_path(movie, review), params: { review: new_attributes }, headers: headers
        review.reload

        expect(review.rating).to eq(new_attributes[:rating])
        expect(review.comment).to eq(new_attributes[:comment])

        expect(UpdateMovieRatingJob).to have_received(:perform_async).with(movie.id)
      end

      it "renders a JSON response with the review" do
        allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)

        review = create(:review, movie: movie, user: user)
        put api_v1_movie_review_path(movie, review), params: { review: valid_attributes }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the review" do
        review = create(:review, movie: movie, user: user)
        put api_v1_movie_review_path(movie, review), params: { review: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE /api/v1/movies/:movie_id/reviews/:id" do
    it "destroys the requested review" do
      allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)

      review = create(:review, movie: movie, user: user)
      expect {
        delete api_v1_movie_review_path(movie, review), headers: headers
      }.to change(Review, :count).by(-1)

      expect(UpdateMovieRatingJob).to have_received(:perform_async).with(movie.id)
    end

    it "returns no content status" do
      allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)

      review = create(:review, movie: movie, user: user)
      delete api_v1_movie_review_path(movie, review), headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
