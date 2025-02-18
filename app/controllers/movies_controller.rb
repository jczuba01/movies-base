class MoviesController < ApplicationController
    before_action :set_movie, only: %i[ show edit update destroy ]

    def index
      @movies = Movie.all
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
        redirect_to @movie, notice: 'Review was successfully created.'
      else
        render :show
      end
    end

    private
      def set_movie
        @movie = Movie.find(params[:id])
      end

      def movie_params
        params.require(:movie).permit(:title, :description, :duration_minutes, :origin_country, :genre_id, :director_id)
      end
      
      def review_params
        params.require(:review).permit(:rating, :comment)
      end
end
