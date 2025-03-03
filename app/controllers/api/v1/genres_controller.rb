class Api::V1::GenresController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :set_genre, only: %i[ show update destroy ]

    def index
        @genres = Genre.all
        render json: @genres, status: :ok
    end

    def show
        render json: @genre, status: :ok
    end

    def create
        @genre = Genre.new(genre_params)

        if @genre.save
            render json: @genre, status: :created
        else
            render json: { errors: @genre.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @genre.update(genre_params)
            render json: @genre, status: :ok
        else
            render json: { errors: @genre.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @genre.destroy
        head :no_content
    end

    private

    def set_genre
        @genre = Genre.find(params[:id])
    end

    def genre_params
        params.require(:genre).permit(
            :name
        )
    end
end
