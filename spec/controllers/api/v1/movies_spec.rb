require 'rails_helper'

RSpec.describe Api::V1::MoviesController, type: :request do
  let!(:genre) { Genre.create(name: "drama") }
  let!(:director) { Director.create(first_name: "Andrzej", last_name: "Wajda", birth_date: "1942-11-17") }

  describe "GET /api/v1/movies" do
    let!(:rambo_movie) { Movie.create(title: "Rambo szambo", description: "desc desc asc", duration_minutes: 120, origin_country: "Niger", genre_id: genre.id, director_id: director.id) }
    let!(:batman_movie) { Movie.create(title: "Batman", description: "black bat", duration_minutes: 240, origin_country: "UK", genre_id: genre.id, director_id: director.id) }

    it "returns status code 200" do
      get "/api/v1/movies"
      expect(response).to have_http_status(:ok)
    end

    it "returns an array of movies" do
      get "/api/v1/movies"

      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to eq(
      {
        "id" => rambo_movie.id,
        "title" => "Rambo szambo",
        "description" => "desc desc asc",
        "duration_minutes" => 120,
        "origin_country" => "Niger",
        "genre_id" => genre.id, 
        "director_id" => director.id,
        "created_at" => json_response.first["created_at"],
        "updated_at" => json_response.first["updated_at"],
        "average_rating" => nil
      })
      expect(json_response.second).to eq(
      {
        "id" => batman_movie.id,
        "title" => "Batman",
        "description" => "black bat",
        "duration_minutes" => 240,
        "origin_country" => "UK",
        "genre_id" => genre.id, 
        "director_id" => director.id,
        "created_at" => json_response.second["created_at"],
        "updated_at" => json_response.second["updated_at"],
        "average_rating" => nil
      })
    end
  end

  describe "GET /api/v1/movies/:id" do
    let!(:movie) { Movie.create(title: "Superman", description: "red-white", duration_minutes: 200, origin_country: "Deutschland", genre_id: genre.id, director_id: director.id) }
    
    it "returns status code 200" do
      get "/api/v1/movies/#{movie.id}"
      expect(response).to have_http_status(:ok)
    end
  
    it "returns the requested movie" do
      get "/api/v1/movies/#{movie.id}"

      json_response = JSON.parse(response.body)
      expect(json_response).to eq(
      {
        "id" => movie.id,
        "title" => "Superman",
        "description" => "red-white",
        "duration_minutes" => 200,
        "genre" => {
          "id" => genre.id,
          "name" => "drama"
        },
        "director" => {
          "id" => director.id,
          "first_name" => "Andrzej",
          "last_name" => "Wajda"
        },
        "created_at" => json_response["created_at"],
        "updated_at" => json_response["updated_at"],
        "average_rating" => nil
      })
    end
  end

  describe "POST /api/v1/movies" do
    context "with valid params" do
      let(:valid_request_body) do
        {
          movie: {
            title: "Avengers",
            description: "Superheroes",
            duration_minutes: 180,
            origin_country: "USA", 
            genre_id: genre.id, 
            director_id: director.id
          }
        }
      end

      it "returns status code 201" do
        post "/api/v1/movies", params: valid_request_body
        expect(response).to have_http_status(:created)
      end

      it "creates a new movie" do
        expect {
          post "/api/v1/movies", params: valid_request_body
        }.to change(Movie, :count).by(1)
      end

      it "returns the created movie" do
        post "/api/v1/movies", params: valid_request_body

        json_response = JSON.parse(response.body)
        movie = Movie.last
        expect(json_response).to eq(
        {
          "id" => movie.id,
          "title" => "Avengers",
          "description" => "Superheroes",
          "duration_minutes" => 180,
          "origin_country" => "USA",
          "genre_id" => genre.id,
          "director_id" => director.id,
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"],
          "average_rating" => nil
        })
      end
    end

    context "with invalid params" do
      let(:invalid_request_body) do
        {
          movie: {
            title: nil,
            description: "Superheroes",
            duration_minutes: 180,
            origin_country: "USA", 
            genre_id: genre.id, 
            director_id: director.id
          }
        }
      end
      
      it "returns status code 422" do
        post "/api/v1/movies", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not create a new movie" do
        expect {
          post "/api/v1/movies", params: invalid_request_body
        }.not_to change(Movie, :count)
      end
      
      it "returns error messages" do
        post "/api/v1/movies", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "PUT /api/v1/movies/:id" do
    let!(:movie) { Movie.create(title: "Iron Man", description: "Marvel", duration_minutes: 120, origin_country: "USA", genre_id: genre.id, director_id: director.id) }
    
    context "with valid params" do
      let(:valid_request_body) do
        {
          movie: {
            title: "Iron Man Updated",
            description: "Marvel",
            duration_minutes: 120,
            origin_country: "USA",
            genre_id: genre.id,
            director_id: director.id
          }
        }
      end
      
      it "returns status code 200" do
        put "/api/v1/movies/#{movie.id}", params: valid_request_body
        expect(response).to have_http_status(:ok)
      end
      
      it "updates the movie" do
        put "/api/v1/movies/#{movie.id}", params: valid_request_body
        
        movie.reload
        expect(movie.title).to eq("Iron Man Updated")
      end
      
      it "returns the updated movie" do
        put "/api/v1/movies/#{movie.id}", params: valid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(
        {
          "id" => movie.id,
          "title" => "Iron Man Updated",
          "description" => "Marvel",
          "duration_minutes" => 120,
          "origin_country" => "USA",
          "genre_id" => genre.id,
          "director_id" => director.id,
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"],
          "average_rating" => nil
        })
      end
    end
    
    context "with invalid params" do
      let(:invalid_request_body) do
        {
          movie: {
            title: nil,
            description: "Marvel",
            duration_minutes: 120,
            origin_country: "USA",
            genre_id: genre.id,
            director_id: director.id
          }
        }
      end
          
      it "returns status code 422" do
        put "/api/v1/movies/#{movie.id}", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not update the movie" do
        put "/api/v1/movies/#{movie.id}", params: invalid_request_body
        
        movie.reload
        expect(movie.title).to eq("Iron Man")
      end
      
      it "returns error messages" do
        put "/api/v1/movies/#{movie.id}", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "DELETE /api/v1/movies/:id" do
    let!(:movie) { Movie.create(title: "Thor", description: "Thunder", duration_minutes: 140, origin_country: "USA", genre_id: genre.id, director_id: director.id) }
    
    it "returns status code 204" do
      delete "/api/v1/movies/#{movie.id}"
      expect(response).to have_http_status(:no_content)
    end
    
    it "deletes the movie" do
      expect {
        delete "/api/v1/movies/#{movie.id}"
      }.to change(Movie, :count).by(-1)
    end
  end
end