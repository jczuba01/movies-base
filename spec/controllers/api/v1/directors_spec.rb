require 'rails_helper'

RSpec.describe Api::V1::DirectorsController, type: :request do
  describe "GET /api/v1/directors" do
    before do
      @martin_director = Director.create(first_name: "Martin", last_name: "Scorsese", birth_date: "1942-11-17")
      @quentin_director = Director.create(first_name: "Quentin", last_name: "Tarantino", birth_date: "1963-03-27")
    end

    it "returns status code 200" do
      get "/api/v1/directors"
      expect(response).to have_http_status(:ok)
    end
    
    it "returns an array of directors" do
      get "/api/v1/directors"
      
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.size).to eq(2)
      expect(json_response.first).to eq(
      {  
        "id" => @martin_director.id,
        "first_name" => "Martin",
        "last_name" => "Scorsese",
        "birth_date" => "1942-11-17",
        "created_at" => json_response.first["created_at"],
        "updated_at" => json_response.first["updated_at"]
      })
      expect(json_response.second).to eq(
      {
        "id" => @quentin_director.id,
        "first_name" => "Quentin",
        "last_name" => "Tarantino",
        "birth_date" => "1963-03-27",
        "created_at" => json_response.second["created_at"],
        "updated_at" => json_response.second["updated_at"]
      })
    end
  end
  
  describe "GET /api/v1/directors/:id" do
    before do
      @director = Director.create(first_name: "Martin", last_name: "Scorsese", birth_date: "1942-11-17")
    end

    it "returns status code 200" do
      get "/api/v1/directors/#{@director.id}"
      expect(response).to have_http_status(:ok)
    end
    
    it "returns the requested director" do
      get "/api/v1/directors/#{@director.id}"
      
      json_response = JSON.parse(response.body)
      expect(json_response).to eq(
      {
        "id" => @director.id,
        "first_name" => "Martin",
        "last_name" => "Scorsese",
        "birth_date" => "1942-11-17",
        "created_at" => json_response["created_at"],
        "updated_at" => json_response["updated_at"]
      })
    end
  end

  describe "POST /api/v1/directors" do
    context "with valid params" do
      let(:valid_request_body) do
        { 
          director: { 
            first_name: "Donald", 
            last_name: "Glover", 
            birth_date: "1983-09-25" 
          } 
        }
      end
          
      it "returns status code 201" do
        post "/api/v1/directors", params: valid_request_body
        expect(response).to have_http_status(:created)
      end
      
      it "creates a new director" do
        expect {
          post "/api/v1/directors", params: valid_request_body
        }.to change(Director, :count).by(1)
      end
      
      it "returns the created director" do
        post "/api/v1/directors", params: valid_request_body
        
        json_response = JSON.parse(response.body)
        director = Director.last
        expect(json_response).to eq(
        {
          "id" => director.id,
          "first_name" => "Donald",
          "last_name" => "Glover",
          "birth_date" => "1983-09-25",
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"]
        })
      end
    end
    
    context "with invalid params" do
      let(:invalid_request_body) do
        { 
          director: { 
            first_name: nil, 
            last_name: "Glover", 
            birth_date: "1983-09-25" 
          } 
        }
      end
      
      let(:expected_error_response) do
        hash_including("errors")
      end
      
      it "returns status code 422" do
        post "/api/v1/directors", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not create a new director" do
        expect {
          post "/api/v1/directors", params: invalid_request_body
        }.not_to change(Director, :count)
      end
      
      it "returns error messages" do
        post "/api/v1/directors", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to have_key("errors")
        expect(json_response["errors"]).not_to be_empty
      end
    end
  end

  describe "PUT /api/v1/directors/:id" do
    let!(:director) { Director.create(first_name: "Alfred", last_name: "Hitchcock", birth_date: "1899-08-13") }
    
    context "with valid params" do
      let(:valid_request_body) do
        { 
          director: { 
            first_name: "Alfred", 
            last_name: "Hitchcock Updated", 
            birth_date: "1899-08-13" 
          } 
        }
      end
      
      it "returns status code 200" do
        put "/api/v1/directors/#{director.id}", params: valid_request_body
        expect(response).to have_http_status(:ok)
      end
      
      it "updates the director" do
        put "/api/v1/directors/#{director.id}", params: valid_request_body
        
        director.reload
        expect(director.last_name).to eq("Hitchcock Updated")
      end
      
      it "returns the updated director" do
        put "/api/v1/directors/#{director.id}", params: valid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to eq(
        {
          "id" => director.id,
          "first_name" => "Alfred",
          "last_name" => "Hitchcock Updated",
          "birth_date" => "1899-08-13",
          "created_at" => json_response["created_at"],
          "updated_at" => json_response["updated_at"]
        })
      end
    end
    
    context "with invalid params" do
      let(:invalid_request_body) do
        { 
          director: { 
            first_name: nil, 
            last_name: "Hitchcock Updated", 
            birth_date: "1899-08-13" 
          } 
        }
      end
      
      let(:expected_error_response) do
        hash_including("errors")
      end
      
      it "returns status code 422" do
        put "/api/v1/directors/#{director.id}", params: invalid_request_body
        expect(response).to have_http_status(:unprocessable_entity)
      end
      
      it "does not update the director" do
        put "/api/v1/directors/#{director.id}", params: invalid_request_body
        
        director.reload
        expect(director.last_name).to eq("Hitchcock")
      end
      
      it "returns error messages" do
        put "/api/v1/directors/#{director.id}", params: invalid_request_body
        
        json_response = JSON.parse(response.body)
        expect(json_response).to match(expected_error_response)
      end
    end
  end

  describe "DELETE /api/v1/directors/:id" do
    let!(:director) { Director.create(first_name: "Francis Ford", last_name: "Coppola", birth_date: "1939-04-07") }
    
    it "returns status code 204" do
      delete "/api/v1/directors/#{director.id}"
      expect(response).to have_http_status(:no_content)
    end
    
    it "deletes the director" do
      expect {
        delete "/api/v1/directors/#{director.id}"
      }.to change(Director, :count).by(-1)
    end
  end
end