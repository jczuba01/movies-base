require 'rails_helper'

RSpec.describe MoviesController, type: :request do
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
    sign_in user, scope: :user
  end

  describe "GET /movies" do
    it "returns a success response" do
      create(:movie, genre: genre, director: director)
      get movies_path
      expect(response).to be_successful
    end
  end

  describe "GET /movies/:id" do
    it "returns a success response" do
      movie = create(:movie, genre: genre, director: director)
      get movie_path(movie)
      expect(response).to be_successful
    end
  end

  describe "GET /movies/new" do
    it "returns a success response" do
      get new_movie_path
      expect(response).to be_successful
    end
  end

  describe "GET /movies/:id/edit" do
    it "returns a success response" do
      movie = create(:movie, genre: genre, director: director)
      get edit_movie_path(movie)
      expect(response).to be_successful
    end
  end

  describe "POST /movies" do
    context "with valid params" do
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

    context "with invalid params" do
      it "does not create a new Movie" do
        expect {
          post movies_path, params: { movie: invalid_attributes }
        }.to change(Movie, :count).by(0)
      end

      it "returns a unprocessable entity response" do
        post movies_path, params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT /movies/:id" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "Updated Title", description: "Updated Description" }
      }

      it "updates the requested movie" do
        movie = create(:movie, genre: genre, director: director)
        patch movie_path(movie), params: { movie: new_attributes }
        movie.reload
        expect(movie.title).to eq("Updated Title")
        expect(movie.description).to eq("Updated Description")
      end

      it "redirects to the movie" do
        movie = create(:movie, genre: genre, director: director)
        patch movie_path(movie), params: { movie: valid_attributes }
        expect(response).to redirect_to(movie_path(movie))
      end
    end

    context "with invalid params" do
      it "returns a unprocessable entity response" dorequire 'rails_helper'

      RSpec.describe ReviewsController, type: :request do
        let(:user) { create(:user) }
        let(:genre) { create(:genre) }
        let(:director) { create(:director) }
        let(:movie) { create(:movie, genre: genre, director: director) }
        let(:valid_attributes) {
          attributes_for(:review)
        }
        let(:invalid_attributes) {
          attributes_for(:review, rating: nil)
        }
      
        before do
          sign_in user, scope: :user
        end
        
        describe "POST /movies/:movie_id/reviews" do
          context "with valid params" do
            it "creates a new Review" do
              expect {
                post movie_reviews_path(movie), params: { review: valid_attributes }
              }.to change(Review, :count).by(1)
            end
      
            it "assigns the current user to the review" do
              post movie_reviews_path(movie), params: { review: valid_attributes }
              expect(Review.last.user).to eq(user)
            end
      
            it "redirects to the movie page with a success notice" do
              post movie_reviews_path(movie), params: { review: valid_attributes }
              expect(response).to redirect_to(movie_path(movie))
              expect(flash[:notice]).to eq("Review was successfully created.")
            end
      
            it "creates a new review successfully" do
              post movie_reviews_path(movie), params: { review: valid_attributes }
              expect(response).to have_http_status(:found)
            end
          end
      
          context "with invalid params" do
            it "does not create a new Review" do
              expect {
                post movie_reviews_path(movie), params: { review: invalid_attributes }
              }.to change(Review, :count).by(0)
            end
      
            it "redirects to the movie page with an error alert" do
              post movie_reviews_path(movie), params: { review: invalid_attributes }
              expect(response).to redirect_to(movie_path(movie))
              expect(flash[:alert]).to eq("Error creating review.")
            end
          end
        end
      
        describe "PATCH/PUT /movies/:movie_id/reviews/:id" do
          let(:review) { create(:review, user: user, movie: movie) }
      
          context "with valid params" do
            let(:new_attributes) {
              { rating: 5, comment: "Updated comment" }
            }
      
            it "updates the requested review" do
              patch movie_review_path(movie, review), params: { review: new_attributes }
              review.reload
              expect(review.rating).to eq(5)
              expect(review.comment).to eq("Updated comment")
            end
      
            it "redirects to the movie page with a success notice" do
              patch movie_review_path(movie, review), params: { review: valid_attributes }
              expect(response).to redirect_to(movie_path(movie))
              expect(flash[:notice]).to eq("Review was successfully updated.")
            end
      
            it "updates the review successfully" do
              patch movie_review_path(movie, review), params: { review: valid_attributes }
              expect(response).to have_http_status(:found)
            end
          end
      
          context "with invalid params" do
            it "redirects to the movie page with an error alert" do
              patch movie_review_path(movie, review), params: { review: invalid_attributes }
              expect(response).to redirect_to(movie_path(movie))
              expect(flash[:alert]).to eq("Error updating review.")
            end
          end
        end
      
        describe "DELETE /movies/:movie_id/reviews/:id" do
          let!(:review) { create(:review, user: user, movie: movie) }
      
          it "destroys the requested review" do
            expect {
              delete movie_review_path(movie, review)
            }.to change(Review, :count).by(-1)
          end
      
          it "redirects to the movie page with a success notice" do
            delete movie_review_path(movie, review)
            expect(response).to redirect_to(movie_path(movie))
            expect(flash[:notice]).to eq("Review was successfully deleted.")
          end
      
          it "deletes the review successfully" do
            delete movie_review_path(movie, review)
            expect(response).to have_http_status(:found)
          end
        end
      end
        movie = create(:movie, genre: genre, director: director)
        patch movie_path(movie), params: { movie: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /movies/:id" do
    it "destroys the requested movie" do
      movie = create(:movie, genre: genre, director: director)
      expect {
        delete movie_path(movie)
      }.to change(Movie, :count).by(-1)
    end

    it "redirects to the movies list" do
      movie = create(:movie, genre: genre, director: director)
      delete movie_path(movie)
      expect(response).to redirect_to(movies_path)
    end
  end
end