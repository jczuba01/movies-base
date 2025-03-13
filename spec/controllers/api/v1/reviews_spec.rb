require 'rails_helper'

RSpec.describe Api::V1::ReviewsController, type: :request do
  let!(:user) { User.create(email: "user@example.com", password: "password") }
  let!(:genre) { Genre.create(name: "Action") }
  let!(:director) { Director.create(first_name: "Martin", last_name: "Scorsese", birth_date: "1942-11-17") }
  let!(:movie) { Movie.create(title: "Kutas", description: "psi kutas", duration_minutes: 6222, origin_country: "Uganda", genre_id: genre.id, director_id: director.id) }
  
  describe "GET /api/v1/movies/:movie_id/reviews" do
    let!(:review1) { Review.create(rating: 4, comment: "Great movie", user_id: user.id, movie_id: movie.id) }
    let!(:review2) { Review.create(rating: 5, comment: "Excellent film", user_id: user.id, movie_id: movie.id) }
    
    it "returns status code 200" do
      get "/api/v1/movies/#{movie.id}/reviews"
      expect(response).to have_http_status(:ok)
    end
    
    it "returns an array of reviews" do
      get "/api/v1/movies/#{movie.id}/reviews"
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to eq(
      {  
        "id" => review1.id,
        "rating" => 4,
        "comment" => "Great movie",
        "user_id" => user.id,
        "movie_id" => movie.id,
        "created_at" => json_response.first["created_at"],
        "updated_at" => json_response.first["updated_at"]
      })
      expect(json_response.second).to eq(
      {
        "id" => review2.id,
        "rating" => 5,
        "comment" => "Excellent film",
        "user_id" => user.id,
        "movie_id" => movie.id,
        "created_at" => json_response.second["created_at"],
        "updated_at" => json_response.second["updated_at"]
      })
    end
  end
  
  describe "GET /api/v1/movies/:movie_id/reviews/:id" do
    let!(:review) { Review.create(rating: 4, comment: "Great movie", user_id: user.id, movie_id: movie.id) }
    
    it "returns status code 200" do
      get "/api/v1/movies/#{movie.id}/reviews/#{review.id}"
      expect(response).to have_http_status(:ok)
    end
    
    it "returns the requested review" do
      get "/api/v1/movies/#{movie.id}/reviews/#{review.id}"
      
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(
      {
        "id" => review.id,
        "rating" => 4,
        "comment" => "Great movie",
        "user_id" => user.id,
        "movie_id" => movie.id,
        "created_at" => json_response["created_at"],
        "updated_at" => json_response["updated_at"]
      })
    end
  end

  describe "POST /api/v1/movies/:movie_id/reviews" do
    before do
      allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)
    end
    
    context "with valid params" do      
      let(:valid_request_body) do
        { 
          review: {
            rating: 4, 
            comment: "Great movie", 
            user_id: user.id
          }
        }
      end
          
      it "returns status code 201" do        
        post "/api/v1/movies/#{movie.id}/reviews", params: valid_request_body
        expect(response).to have_http_status(:created)
      end
      
      it "creates a new review" do        
        expect {
          post "/api/v1/movies/#{movie.id}/reviews", params: valid_request_body
        }.to change(Review, :count).by(1)
      end
      
      it "returns the created review" do       
        post "/api/v1/movies/#{movie.id}/reviews", params: valid_request_body
        
        json_response = JSON.parse(response.body)
        review = Review.last
        expect(json_response).to eq(
        {
          "id" => review.id,
          "rating" => 4,
          "comment" => "Great movie",
          "user_id" => user.id,
          "movie_id" => movie.id,
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"]
        })
      end
    end
          
    context "with invalid params" do
      let(:invalid_request_body) do
        { 
          review: {
            rating: nil, 
            comment: nil, 
            user_id: user.id
          }
        }
      end
            
      it "returns status code 422" do
        post "/api/v1/movies/#{movie.id}/reviews", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not create a new review" do
        expect {
          post "/api/v1/movies/#{movie.id}/reviews", params: invalid_request_body
        }.not_to change(Review, :count)
      end
      
      it "returns error messages" do
        post "/api/v1/movies/#{movie.id}/reviews", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "PUT /api/v1/movies/:movie_id/reviews/:id" do
    let!(:review) { Review.create(rating: 3, comment: "Decent movie", user_id: user.id, movie_id: movie.id) }
    
    before do
      allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)
    end
    
    context "with valid params" do
      let(:valid_request_body) do
        { 
          review: {
            rating: 4, 
            comment: "Actually, it was better than I thought", 
            user_id: user.id
          }
        }
      end
      
      it "returns status code 200" do      
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: valid_request_body
        expect(response).to have_http_status(:ok)
      end
      
      it "updates the review" do        
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: valid_request_body
        
        review.reload
        expect(review.rating).to eq(4)
        expect(review.comment).to eq("Actually, it was better than I thought")
      end
      
      it "returns the updated review" do        
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: valid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(
        {
          "id" => review.id,
          "rating" => 4,
          "comment" => "Actually, it was better than I thought",
          "user_id" => user.id,
          "movie_id" => movie.id,
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"]
        })
      end
    end
    
    context "with invalid params" do
      let(:invalid_request_body) do
        { 
          review: { 
            rating: nil, 
            comment: nil, 
            user_id: user.id
          }
        }
      end
      
      it "returns status code 422" do
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not update the review" do
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: invalid_request_body
        
        review.reload
        expect(review.rating).to eq(3)
        expect(review.comment).to eq("Decent movie")
      end
      
      it "returns error messages" do
        put "/api/v1/movies/#{movie.id}/reviews/#{review.id}", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "DELETE /api/v1/movies/:movie_id/reviews/:id" do
    let!(:review) { Review.create(rating: 3, comment: "Decent movie", user_id: user.id, movie_id: movie.id) }
    
    before do
      allow(UpdateMovieRatingJob).to receive(:perform_async).and_return(true)
    end
    
    it "returns status code 204" do
      delete "/api/v1/movies/#{movie.id}/reviews/#{review.id}"
      expect(response).to have_http_status(:no_content)
    end
    
    it "deletes the review" do      
      expect {
        delete "/api/v1/movies/#{movie.id}/reviews/#{review.id}"
      }.to change(Review, :count).by(-1)
    end
  end
end