class Api::V1::MoviesController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :set_movie, only: %i[ show update destroy ]
    
    def index
        @movies = Movie.all
        render json: @movies, status: :ok
    end

    def show
        render json: MovieSerializer.new(@movie).serialize, status: :ok
    end

    def create
        @movie = Movie.new(movie_params)
        
        if @movie.save
            render json: @movie, status: :created
        else
            render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @movie.update(movie_params)
            render json: @movie, status: :ok
        else
            render json: { errors: @movie.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def destroy
        @movie.destroy
        head :no_content
    end

    private
    
    def set_movie
        @movie = Movie.find(params[:id])
    end
    
    def movie_params
        params.require(:movie).permit(
            :title,
            :description,
            :duration_minutes,
            :origin_country,
            :genre_id,
            :director_id
        )
    end
end