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
        "average_rating" => nil,
        "genre" => {
          "id" => genre.id,
          "name" => "drama"
        },
        "director" => {
          "id" => director.id,
          "first_name" => "Andrzej",
          "last_name" => "Wajda"
        }
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
        "average_rating" => nil,
        "genre" => {
          "id" => genre.id,
          "name" => "drama"
        },
        "director" => {
          "id" => director.id,
          "first_name" => "Andrzej",
          "last_name" => "Wajda"
        }
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

  describe "Filtering and sorting movies" do
    let!(:genre1) { Genre.create(name: "drama") }
    let!(:genre2) { Genre.create(name: "sci-fi") }
    let!(:director1) { Director.create(first_name: "Steven", last_name: "Spielberg", birth_date: "1946-12-18") }
    let!(:director2) { Director.create(first_name: "Christopher", last_name: "Nolan", birth_date: "1970-07-30") }
    
    let!(:movie1) { Movie.create(title: "Saving Private Ryan", description: "WWII drama", duration_minutes: 169, origin_country: "USA", genre_id: genre1.id, director_id: director1.id) }
    let!(:movie2) { Movie.create(title: "Interstellar", description: "Space exploration", duration_minutes: 169, origin_country: "USA", genre_id: genre2.id, director_id: director2.id) }
    let!(:movie3) { Movie.create(title: "Inception", description: "Dream heist", duration_minutes: 148, origin_country: "USA", genre_id: genre2.id, director_id: director2.id) }
    let!(:movie4) { Movie.create(title: "Schindler's List", description: "Holocaust drama", duration_minutes: 195, origin_country: "USA", genre_id: genre1.id, director_id: director1.id) }
  
    context "when filtering by title" do
      it "returns movies that match the title filter" do
        get "/api/v1/movies?title=Inter"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first["title"]).to eq("Interstellar")
      end
    end
  
    context "when filtering by genre_name" do
      it "returns movies that match the genre_name filter" do
        get "/api/v1/movies?genre_name=sci-fi"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |m| m["title"] }).to contain_exactly("Interstellar", "Inception")
      end
    end
  
    context "when filtering by director_last_name" do
      it "returns movies that match the director_last_name filter" do
        get "/api/v1/movies?director_last_name=Nolan"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |m| m["title"] }).to contain_exactly("Interstellar", "Inception")
      end
    end
  
    context "when filtering by max_duration" do
      it "returns movies with duration less than or equal to max_duration" do
        get "/api/v1/movies?max_duration=150"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(1)
        expect(json_response.first["title"]).to eq("Inception")
      end
    end
  
    context "when filtering by origin_country" do
      it "returns movies from the specified country" do
        get "/api/v1/movies?origin_country=USA"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(4)
      end
    end
  
    context "when sorting by title" do
      it "returns movies sorted by title in ascending order" do
        get "/api/v1/movies?sort=title&direction=asc"
        
        json_response = JSON.parse(response.body)
        titles = json_response.map { |m| m["title"] }
        expect(titles).to eq(titles.sort)
      end
  
      it "returns movies sorted by title in descending order" do
        get "/api/v1/movies?sort=title&direction=desc"
        
        json_response = JSON.parse(response.body)
        titles = json_response.map { |m| m["title"] }
        expect(titles).to eq(titles.sort.reverse)
      end
    end
  
    context "when sorting by duration_minutes" do
      it "returns movies sorted by duration in ascending order" do
        get "/api/v1/movies?sort=duration_minutes&direction=asc"
        
        json_response = JSON.parse(response.body)
        durations = json_response.map { |m| m["duration_minutes"] }
        expect(durations).to eq(durations.sort)
      end
  
      it "returns movies sorted by duration in descending order" do
        get "/api/v1/movies?sort=duration_minutes&direction=desc"
        
        json_response = JSON.parse(response.body)
        durations = json_response.map { |m| m["duration_minutes"] }
        expect(durations).to eq(durations.sort.reverse)
      end
    end
  
    context "when combining multiple filters" do
      it "returns movies that match all filters" do
        get "/api/v1/movies?genre_name=drama&director_last_name=Spielberg"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.map { |m| m["title"] }).to contain_exactly("Saving Private Ryan", "Schindler's List")
      end
    end
  
    context "when combining filters with sorting" do
      it "returns filtered movies with the specified sorting" do
        get "/api/v1/movies?genre_name=sci-fi&sort=title&direction=desc"
        
        json_response = JSON.parse(response.body)
        expect(json_response.size).to eq(2)
        expect(json_response.first["title"]).to eq("Interstellar")
        expect(json_response.last["title"]).to eq("Inception")
      end
    end
  end
end