require 'rails_helper'

RSpec.describe ReviewsController, type: :request do
  before do
    allow_any_instance_of(ApplicationController).to receive(:authenticate_user!).and_return(true)
  end
  
  let(:user) { create(:user) }
  let(:movie) { create(:movie) }
  let(:review) { create(:review, movie: movie, user: user) }
  let(:valid_attributes) { { rating: 4, comment: "This is a test comment", user_id: user.id } }
  let(:invalid_attributes) { { rating: nil, comment: "" } }

  describe "POST /movies/:movie_id/reviews" do
    context "with valid parameters" do
      it "creates a new Review" do
        expect {
          post movie_reviews_path(movie), params: { review: valid_attributes }
        }.to change(Review, :count).by(1)
      end

      it "redirects to the movie" do
        post movie_reviews_path(movie), params: { review: valid_attributes }
        expect(response).to redirect_to(movie_path(movie))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Review" do
        expect {
          post movie_reviews_path(movie), params: { review: invalid_attributes }
        }.not_to change(Review, :count)
      end

      it "redirects to the movie with an alert" do
        post movie_reviews_path(movie), params: { review: invalid_attributes }
        expect(response).to redirect_to(movie_path(movie))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "PATCH /movies/:movie_id/reviews/:id" do
    context "with valid parameters" do
      let(:new_attributes) { { rating: 5, comment: "Updated comment" } }

      it "updates the requested review" do
        patch movie_review_path(movie, review), params: { review: new_attributes }
        review.reload
        expect(review.rating).to eq(5)
        expect(review.comment).to eq("Updated comment")
      end

      it "redirects to the movie" do
        patch movie_review_path(movie, review), params: { review: new_attributes }
        expect(response).to redirect_to(movie_path(movie))
      end
    end

    context "with invalid parameters" do
      it "does not update the review" do
        original_rating = review.rating
        original_comment = review.comment
        
        patch movie_review_path(movie, review), params: { review: invalid_attributes }
        
        review.reload
        expect(review.rating).to eq(original_rating)
        expect(review.comment).to eq(original_comment)
      end

      it "redirects to the movie with an alert" do
        patch movie_review_path(movie, review), params: { review: invalid_attributes }
        expect(response).to redirect_to(movie_path(movie))
        expect(flash[:alert]).to be_present
      end
    end
  end

  describe "DELETE /movies/:movie_id/reviews/:id" do
    it "destroys the requested review" do
      review
      expect {
        delete movie_review_path(movie, review)
      }.to change(Review, :count).by(-1)
    end

    it "redirects to the movie" do
      delete movie_review_path(movie, review)
      expect(response).to redirect_to(movie_path(movie))
    end
  end
end