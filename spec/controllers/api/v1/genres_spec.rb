require 'rails_helper'

RSpec.describe "Api::V1::Genres", type: :request do
  let(:valid_attributes) { attributes_for(:genre) }
  let(:invalid_attributes) { attributes_for(:genre, name: nil) }
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /api/v1/genres" do
    it "returns a success response" do
      genre = create(:genre)
      get api_v1_genres_path, headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(JSON.parse(genre.to_json))
    end
  end

  describe "GET /api/v1/genres/:id" do
    it "returns a success response" do
      genre = create(:genre)
      get api_v1_genre_path(genre), headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(genre.to_json))
    end
  end

  describe "POST /api/v1/genres" do
    context "with valid params" do
      it "creates a new Genre" do
        expect {
          post api_v1_genres_path, params: { genre: valid_attributes }, headers: headers
        }.to change(Genre, :count).by(1)
      end

      it "renders a JSON response with the new genre" do
        post api_v1_genres_path, params: { genre: valid_attributes }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')

        response_body = JSON.parse(response.body)
        puts "Genre from API response: #{response_body.inspect}"

        created_genre = Genre.find(response_body["id"])
        puts "Same genre from database: #{created_genre.inspect}"

        expect(response_body["name"]).to eq(valid_attributes[:name])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new genre" do
        post api_v1_genres_path, params: { genre: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "PUT /api/v1/genres/:id" do
    context "with valid params" do
      let(:new_attributes) { attributes_for(:genre) }

      it "updates the requested genre" do
        genre = create(:genre)
        put api_v1_genre_path(genre), params: { genre: new_attributes }, headers: headers
        genre.reload
        expect(genre.name).to eq(new_attributes[:name])
      end

      it "renders a JSON response with the genre" do
        genre = create(:genre)
        put api_v1_genre_path(genre), params: { genre: valid_attributes }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the genre" do
        genre = create(:genre)
        put api_v1_genre_path(genre), params: { genre: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE /api/v1/genres/:id" do
    it "destroys the requested genre" do
      genre = create(:genre)
      expect {
        delete api_v1_genre_path(genre), headers: headers
      }.to change(Genre, :count).by(-1)
    end

    it "returns no content status" do
      genre = create(:genre)
      delete api_v1_genre_path(genre), headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
