class Api::V1::MoviesController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :set_movie, only: %i[ show update destroy ]

    def index
        if params[:director_id]
          @director = Director.find_by(id: params[:director_id])

          if @director
            @movies = @director.movies
            render json: @movies.as_json(include: {
                genre: { only: [ :id, :name ] },
                director: { only: [ :id, :first_name, :last_name ] }
            }), status: :ok
          else
            render json: { error: "Director not found" }, status: :not_found
          end
        elsif params[:genre_id]
          @genre = Genre.find_by(id: params[:genre_id])

          if @genre
            @movies = @genre.movies
            render json: @movies.as_json(include: {
                genre: { only: [ :id, :name ] },
                director: { only: [ :id, :first_name, :last_name ] }
            }), status: :ok
          else
            render json: { error: "Genre not found" }, status: :not_found
          end
        else
          @movies = Movie.all
          render json: @movies.as_json(include: {
            genre: { only: [ :id, :name ] },
            director: { only: [ :id, :first_name, :last_name ] }
          }), status: :ok
        end
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
