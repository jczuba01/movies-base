require 'rails_helper'

RSpec.describe Api::V1::DirectorsController, type: :controller do
  let(:valid_attributes) { attributes_for(:director) }
  let(:invalid_attributes) { attributes_for(:director, first_name: nil, last_name: nil, birth_date: nil) }

  before do
    request.headers['CONTENT_TYPE'] = 'application/json'
    request.headers['ACCEPT'] = 'application/json'
  end

  describe "GET /api/v1/directors" do
    it "returns a success response" do
      director = create(:director)
      get :index
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to include(JSON.parse(director.to_json))
    end
  end

  describe "GET /api/v1/directors/:id" do
    it "returns a success response" do
      director = create(:director)
      get :show, params: {id: director.to_param}
      expect(response).to be_successful
      expect(JSON.parse(response.body)).to eq(JSON.parse(director.to_json))
    end
  end

  describe "POST /api/v1/directors" do
    context "with valid params" do
      it "creates a new Director" do
        expect {
          post :create, params: {director: valid_attributes}
        }.to change(Director, :count).by(1)
      end

      it "renders a JSON response with the new director" do
        post :create, params: {director: valid_attributes}
        expect(response).to have_http_status(:created)
        expect(response.content_type).to include('application/json')
        
        response_body = JSON.parse(response.body)
        puts "Director from API response: #{response_body.inspect}"
        
        created_director = Director.find(response_body["id"])
        puts "Same director from database: #{created_director.inspect}"
        
        expect(response_body["first_name"]).to eq(valid_attributes[:first_name])
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the new director" do
        post :create, params: {director: invalid_attributes}
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
        put :update, params: {id: director.to_param, director: new_attributes}
        director.reload
        expect(director.first_name).to eq(new_attributes[:first_name])
        expect(director.last_name).to eq(new_attributes[:last_name])
      end

      it "renders a JSON response with the director" do
        director = create(:director)
        put :update, params: {id: director.to_param, director: valid_attributes}
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to include('application/json')
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors for the director" do
        director = create(:director)
        put :update, params: {id: director.to_param, director: invalid_attributes}
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to include('application/json')
      end
    end
  end

  describe "DELETE /api/v1/directors/:id" do
    it "destroys the requested director" do
      director = create(:director)
      expect {
        delete :destroy, params: {id: director.to_param}
      }.to change(Director, :count).by(-1)
    end

    it "returns no content status" do
      director = create(:director)
      delete :destroy, params: {id: director.to_param}
      expect(response).to have_http_status(:no_content)
    end
  end
end