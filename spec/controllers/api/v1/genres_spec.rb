require 'rails_helper'

RSpec.describe Api::V1::GenresController, type: :request do
  describe "GET /api/v1/genres" do
    before { Genre.destroy_all }
    
    let!(:horror_genre) { Genre.create(name: "horror") }
    let!(:comedy_genre) { Genre.create(name: "comedy") }
    
    it "returns status code 200" do
      get "/api/v1/genres"
      expect(response).to have_http_status(:ok)
    end

    it "returns an array of genres" do
      get "/api/v1/genres"

      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to eq(
        {
          "id" => horror_genre.id,
          "name" => "horror",
          "created_at" => json_response.first["created_at"],
          "updated_at" => json_response.first["updated_at"]
        })
      expect(json_response.second).to eq(
        {
          "id" => comedy_genre.id,
          "name" => "comedy",
          "created_at" => json_response.second["created_at"],
          "updated_at" => json_response.second["updated_at"]
        }
      )
    end
  end

  describe "GET /api/v1/genres/:id" do
    let!(:genre) { Genre.create(name: "sci-fi") }
    
    it "returns status code 200" do
      get "/api/v1/genres/#{genre.id}"
      expect(response).to have_http_status(:ok)
    end

    it "returns the requested genre" do
      get "/api/v1/genres/#{genre.id}"

      json_response = JSON.parse(response.body)
      expect(json_response).to eq(
      {
        "id" => genre.id,
        "name" => "sci-fi",
        "created_at" => json_response["created_at"],
        "updated_at" => json_response["updated_at"]
      })
    end
  end

  describe "POST /api/v1/genres" do
    context "with valid params" do
      let(:valid_request_body) do
        {
          genre: {
            name: "fantasy"
          }
        }
      end

      it "returns status code 201" do
        post "/api/v1/genres", params: valid_request_body
        expect(response).to have_http_status(:created)
      end
      
      it "creates a new genre" do
        expect {
          post "/api/v1/genres", params: valid_request_body
        }.to change(Genre, :count).by(1)
      end

      it "returns the created genre" do
        post "/api/v1/genres", params: valid_request_body

        json_response = JSON.parse(response.body)
        genre = Genre.last
        expect(json_response).to eq(
        {
            "id" => genre.id,
            "name" => "fantasy",
            "created_at" => json_response["created_at"],
            "updated_at" => json_response["updated_at"]
        })
      end
    end

    context "with invalid params" do
      let(:invalid_request_body) do
        {
          genre: {
            name: nil
          }
        }
      end

      it "returns status code 422" do
        post "/api/v1/genres", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not create a new genre" do
        expect {
          post "/api/v1/genres", params: invalid_request_body
        }.not_to change(Genre, :count)
      end

      it "returns error messages" do
        post "/api/v1/genres", params: invalid_request_body

        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "PUT /api/v1/genres/:id" do
    let!(:genre) { Genre.create(name: "historical") }

    context "with valid params" do
      let(:valid_request_body) do
        {
          genre: {
            name: "historical updated"
          }
        }
      end

      it "returns status code 200" do
        put "/api/v1/genres/#{genre.id}", params: valid_request_body
        expect(response).to have_http_status(:ok)
      end
      
      it "updates the genre" do
        put "/api/v1/genres/#{genre.id}", params: valid_request_body
        
        genre.reload
        expect(genre.name).to eq("historical updated")
      end

      it "returns the updated genre" do
        put "/api/v1/genres/#{genre.id}", params: valid_request_body

        json_response = JSON.parse(response.body)
        expect(json_response).to eq(
        {
          "id" => genre.id,
          "name" => "historical updated",
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"]
        })
      end
    end  

    context "with invalid params" do
      let(:invalid_request_body) do
        {
          genre: {
            name: nil
          }
        }
      end

      let(:expected_error_response) do
        hash_including("errors")
      end

      it "returns status code 422" do
        put "/api/v1/genres/#{genre.id}", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it "does not update the genre" do
        put "/api/v1/genres/#{genre.id}", params: invalid_request_body
        
        genre.reload
        expect(genre.name).to eq("historical")
      end

      it "returns error messages" do
        put "/api/v1/genres/#{genre.id}", params: invalid_request_body

        json_response = JSON.parse(response.body)
        expect(json_response).to match(expected_error_response)
      end
    end
  end

  describe "DELETE /api/v1/genres/:id" do
    let!(:genre) { Genre.create(name: "romantic") }

    it "returns status code 204" do
      delete "/api/v1/genres/#{genre.id}"
      expect(response).to have_http_status(:no_content)
    end

    it "deletes the genre" do
      expect {
        delete "/api/v1/genres/#{genre.id}"
      }.to change(Genre, :count).by(-1)
    end
  end
end