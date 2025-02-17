class MoviesController < ApplicationController
  before_action :authenticate_user!  
  before_action :set_movie, only: [:show, :edit, :update, :destroy]

  def index
    @movies = current_user.movies
  end

  def show
  end

  def new
    @movie = current_user.movies.build
  end

  def create
    @movie = current_user.movies.build(movie_params)
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

  private
    def set_movie
      @movie = current_user.movies.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:title, :description, :duration_minutes, :origin_country, :genre_id, :director_id)
    end
end