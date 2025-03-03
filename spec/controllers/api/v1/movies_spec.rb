require 'rails_helper'

RSpec.describe "Api::V1::Movies", type: :request do
  let(:genre) { create(:genre) }
  let(:director) { create(:director) }
  
  let(:valid_attributes) { 
    attributes = attributes_for(:movie)
    attributes[:genre_id] = genre.id
    attributes[:director_id] = director.id
    attributes
  }
  let(:invalid_attributes) { 
    attributes = attributes_for(:movie, title: nil, duration_minutes: nil)
    attributes[:genre_id] = genre.id
    attributes[:director_id] = director.id
    attributes
  }
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /api/v1/movies" do
    it "returns a success response" do
      movie = create(:movie)
      get api_v1_movies_path, headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(JSON.parse(movie.to_json))
    end
  end

  describe "GET /api/v1/movies/:id" do
    it "returns a success response with serialized data" do
      movie = create(:movie)
      get api_v1_movie_path(movie), headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(MovieSerializer.new(movie).serialize.to_json))
    end
  end

  describe "POST /api/v1/movies" do
    context "with valid params" do
      it "creates a new Movie" do
        expect {
          post api_v1_movies_path, params: { movie: valid_attributes }, headers: headers
        }.to change(Movie, :count).by(1)
      end

      it "renders a JSON response with the new movie" do
        post api_v1_movies_path, params: { movie: valid_attributes }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        
        response_body = JSON.parse(response.body)
        puts "Movie from API response: #{response_body.inspect}"
        
        created_movie = Movie.find(response_body["id"])
        puts "Same movie from database: #{created_movie.inspect}"
        
        expect(response_body["title"]).to eq(valid_attributes[:title])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new movie" do
        post api_v1_movies_path, params: { movie: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "PUT /api/v1/movies/:id" do
    context "with valid params" do
      let(:new_attributes) { attributes_for(:movie) }

      it "updates the requested movie" do
        movie = create(:movie)
        put api_v1_movie_path(movie), params: { movie: new_attributes }, headers: headers
        movie.reload
        expect(movie.title).to eq(new_attributes[:title])
        expect(movie.description).to eq(new_attributes[:description])
      end

      it "renders a JSON response with the movie" do
        movie = create(:movie)
        put api_v1_movie_path(movie), params: { movie: valid_attributes }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the movie" do
        movie = create(:movie)
        put api_v1_movie_path(movie), params: { movie: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE /api/v1/movies/:id" do
    it "destroys the requested movie" do
      movie = create(:movie)
      expect {
        delete api_v1_movie_path(movie), headers: headers
      }.to change(Movie, :count).by(-1)
    end

    it "returns no content status" do
      movie = create(:movie)
      delete api_v1_movie_path(movie), headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end