class MoviesController < ApplicationController
    before_action :set_movie, only: %i[ show edit update destroy ]

    def index
      if params[:director_id]
        @director = Director.find_by(id: params[:director_id])
        
        if @director
          @movies = @director.movies
        else
          flash[:alert] = "Director not found"
          redirect_to directors_path
          return
        end
      elsif params[:genre_id]
        @genre = Genre.find_by(id: params[:genre_id])

        if @genre
          @movies = @genre.movies
        else
          flash[:alert] = "Genre not found"
          redirect_to genres_path
          return
        end
      else
        @movies = Movie.all
      end
    end

    def show
      @movie = Movie.find(params[:id])
      @reviews = @movie.reviews
    end

    def new
      @movie = Movie.new
    end

    def create
      @movie = Movie.new(movie_params)
      if @movie.save
        redirect_to @movie
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @movie.update(movie_params)
        redirect_to @movie
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @movie.destroy
      redirect_to movies_path
    end

    def create_review
      @movie = Movie.find(params[:id])
      @review = @movie.reviews.new(review_params)
      @review.user = current_user

      if @review.save
        redirect_to @movie, notice: "Review was successfully created."
      else
        @reviews = @movie.reviews
        render :show
      end
    end

    private
      def set_movie
        @movie = Movie.find(params[:id])
      end

      def movie_params
        params.require(:movie).permit(:title, :description, :duration_minutes, :origin_country, :genre_id, :director_id, :cover)
      end

      def review_params
        params.require(:review).permit(:rating, :comment)
      end
end
