require 'rails_helper'

RSpec.describe "Api::V1::Directors", type: :request do
  let(:valid_attributes) { attributes_for(:director) }
  let(:invalid_attributes) { attributes_for(:director, first_name: nil, last_name: nil, birth_date: nil) }
  let(:headers) { { "ACCEPT" => "application/json" } }

  describe "GET /api/v1/directors" do
    it "returns a success response" do
      director = create(:director)
      get api_v1_directors_path, headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(JSON.parse(director.to_json))
    end
  end

  describe "GET /api/v1/directors/:id" do
    it "returns a success response" do
      director = create(:director)
      get api_v1_director_path(director), headers: headers
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(director.to_json))
    end
  end

  describe "POST /api/v1/directors" do
    context "with valid params" do
      it "creates a new Director" do
        expect {
          post api_v1_directors_path, params: { director: valid_attributes }, headers: headers
        }.to change(Director, :count).by(1)
      end

      it "renders a JSON response with the new director" do
        post api_v1_directors_path, params: { director: valid_attributes }, headers: headers
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')

        response_body = JSON.parse(response.body)
        created_director = Director.find(response_body["id"])

        expect(response_body["first_name"]).to eq(valid_attributes[:first_name])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new director" do
        post api_v1_directors_path, params: { director: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "PUT /api/v1/directors/:id" do
    context "with valid params" do
      let(:new_attributes) { attributes_for(:director) }

      it "updates the requested director" do
        director = create(:director)
        put api_v1_director_path(director), params: { director: new_attributes }, headers: headers
        director.reload
        expect(director.first_name).to eq(new_attributes[:first_name])
        expect(director.last_name).to eq(new_attributes[:last_name])
      end

      it "renders a JSON response with the director" do
        director = create(:director)
        put api_v1_director_path(director), params: { director: valid_attributes }, headers: headers
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the director" do
        director = create(:director)
        put api_v1_director_path(director), params: { director: invalid_attributes }, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE /api/v1/directors/:id" do
    it "destroys the requested director" do
      director = create(:director)
      expect {
        delete api_v1_director_path(director), headers: headers
      }.to change(Director, :count).by(-1)
    end

    it "returns no content status" do
      director = create(:director)
      delete api_v1_director_path(director), headers: headers
      expect(response).to have_http_status(:no_content)
    end
  end
end
