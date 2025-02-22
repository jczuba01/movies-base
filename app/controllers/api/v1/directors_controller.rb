class Api::V1::DirectorsController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :set_director, only: %i[ show update destroy ]

    def index
        @directors = Director.all
        render json: @directors, status: :ok
    end

    def show
        render json: @director, status: :ok
    end

    def create
        @director = Director.new(director_params)

        if @director.save
            render json: @director, status: :created
        else
            render json: { errors: @director.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @director.update(director_params)
            render json: @director, status: :ok
        else
            render json: { errors: @director.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @director.destroy
        head :no_content
    end

    private

    def set_director
        @director = Director.find(params[:id])
    end

    def director_params
        params.require(:director).permit(
            :first_name,
            :last_name,
            :birth_date
        )
    end
end