require 'rails_helper'

RSpec.describe "Api::V1::Directors", type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }

  def valid_director_body
    director = build(:director)
    {
      first_name: director.first_name,
      last_name: director.last_name,
      birth_date: director.birth_date
    }
  end

  let(:invalid_director_body) do
    {
      first_name: nil,
      last_name: nil,
      birth_date: nil
    }
  end

  def verify_director_response(response_data, director)
    expect(response_data["id"]).to eq(director.id)
    expect(response_data["first_name"]).to eq(director.first_name)
    expect(response_data["last_name"]).to eq(director.last_name)
    expect(response_data["birth_date"]).to eq(director.birth_date.as_json)
  end

  def verify_director_response_with_params(response_data, params)
    expect(response_data["id"]).to be_present
    expect(response_data["first_name"]).to eq(params[:first_name])
    expect(response_data["last_name"]).to eq(params[:last_name])
    expect(response_data["birth_date"]).to be_present
  end

  def verify_error_response
    expect(response).to have_http_status(:unprocessable_entity)
    expect(response.content_type).to include('application/json')
    
    response_data = JSON.parse(response.body)
    expect(response_data["errors"]).to be_present
  end

  describe "GET /api/v1/directors" do
    it "returns a success response with all directors" do
      directors = create_list(:director, 3)
      
      get "/api/v1/directors", headers: headers
      
      response_data = JSON.parse(response.body)
      expect(response).to be_successful
      binding.pry
      
      expect(response_data.length).to eq(3)
      directors.each do |director|
        director_in_response = response_data.find { |d| d["id"] == director.id }
        verify_director_response(director_in_response, director)
      end
    end
  end

  describe "GET /api/v1/directors/:id" do
    it "returns a success response" do
      director = create(:director)
      
      get "/api/v1/directors/#{director.id}", headers: headers
      
      expect(response).to be_successful
      verify_director_response(JSON.parse(response.body), director)
    end
  end

  describe "POST /api/v1/directors" do
    context "with valid params" do
      it "creates a new Director" do
        body = valid_director_body
        
        expect {
          post "/api/v1/directors", params: { director: body }, headers: headers
        }.to change(Director, :count).by(1)
      end

      it "renders a JSON response with the new director" do
        body = valid_director_body
        
        post "/api/v1/directors", params: { director: body }, headers: headers
        
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        verify_director_response_with_params(JSON.parse(response.body), body)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new director" do
        post "/api/v1/directors", params: { director: invalid_director_body }, headers: headers
        verify_error_response
      end
    end
  end

  describe "PUT /api/v1/directors/:id" do
    context "with valid params" do
      it "updates the requested director" do
        director = create(:director)
        body = valid_director_body
        
        put "/api/v1/directors/#{director.id}", params: { director: body }, headers: headers
        
        director.reload
        expect(director.first_name).to eq(body[:first_name])
        expect(director.last_name).to eq(body[:last_name])
        expect(director.birth_date.to_s).to eq(body[:birth_date].to_s)
      end

      it "renders a JSON response with the updated director" do
        director = create(:director)
        body = valid_director_body
        
        put "/api/v1/directors/#{director.id}", params: { director: body }, headers: headers
        
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
        verify_director_response_with_params(JSON.parse(response.body), body)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the director" do
        director = create(:director)
        
        put "/api/v1/directors/#{director.id}", params: { director: invalid_director_body }, headers: headers
        verify_error_response
      end
    end
  end

  describe "DELETE /api/v1/directors/:id" do
    it "destroys the requested director" do
      director = create(:director)
      
      expect {
        delete "/api/v1/directors/#{director.id}", headers: headers
      }.to change(Director, :count).by(-1)
    end

    it "returns no content status" do
      director = create(:director)
      
      delete "/api/v1/directors/#{director.id}", headers: headers
      
      expect(response).to have_http_status(:no_content)
    end
  end
end