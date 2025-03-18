class MoviesController < ApplicationController
  before_action :set_movie, only: %i[ show edit update destroy ]
  require 'open-uri'

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
    @reviews = @movie.reviews
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    
    if session[:poster_path].present?
      begin
        poster_url = "https://image.tmdb.org/t/p/w500#{session[:poster_path]}"
        @movie.cover.attach(io: URI.open(poster_url), 
                          filename: "#{@movie.title.parameterize}.jpg", 
                          content_type: "image/jpeg")
      rescue
      end
      session.delete(:poster_path)
    end
    
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

  def fetch_details
    if params[:title].present?
      @movie = TmdbService.new(params[:title]).fetch_movie_details
      
      if @movie
        @poster_path = TmdbService.new(params[:title]).fetch_poster_path
        session[:poster_path] = @poster_path if @poster_path
        flash.now[:notice] = "Found movie: #{@movie.title}"
      else
        @movie = Movie.new
        flash.now[:alert] = "No movies found with that title"
      end
    else
      @movie = Movie.new
    end
    
    render :new
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