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
    @movie = Movie.find(params[:id])
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
    @movie = Movie.new
    
    if params[:title].present?
      api_key = Rails.application.credentials.tmdb[:api_key]
      
      require 'net/http'
      require 'uri'
      require 'json'
      
      # Step 1: Search for the movie by title
      query = URI.encode_www_form_component(params[:title])
      uri = URI.parse("https://api.themoviedb.org/3/search/movie?query=#{query}")
      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{api_key}"
      
      http = Net::HTTP.new(uri.hostname, uri.port)
      http.use_ssl = true
      
      response = http.request(request)
      search_results = JSON.parse(response.body)
      
      if search_results["results"] && search_results["results"].any?
        # Step 2: Get the first movie ID from results
        movie_id = search_results["results"][0]["id"]
        
        # Step 3: Get detailed information about the movie
        details_uri = URI.parse("https://api.themoviedb.org/3/movie/#{movie_id}?append_to_response=credits")
        details_request = Net::HTTP::Get.new(details_uri)
        details_request["Authorization"] = "Bearer #{api_key}"
        
        details_response = http.request(details_request)
        movie_details = JSON.parse(details_response.body)
        
        # Step 4: Populate the @movie object with data from API
        @movie.title = movie_details["title"]
        @movie.description = movie_details["overview"]
        @movie.duration_minutes = movie_details["runtime"]
        
        # Get origin country
        if movie_details["production_countries"] && movie_details["production_countries"].any?
          @movie.origin_country = movie_details["production_countries"][0]["iso_3166_1"]
        end
        
        # Handle genre - find or create
        if movie_details["genres"] && movie_details["genres"].any?
          genre_name = movie_details["genres"][0]["name"]
          genre = Genre.find_by("LOWER(name) = ?", genre_name.downcase)
          
          # Create genre if it doesn't exist
          if genre.nil?
            genre = Genre.create(name: genre_name)
            flash.now[:notice] = flash.now[:notice].to_s + " Created new genre: #{genre_name}."
          end
          
          @movie.genre_id = genre.id if genre.persisted?
        end
        
        # Handle director - find or create
        if movie_details["credits"] && movie_details["credits"]["crew"]
          director = movie_details["credits"]["crew"].find { |crew_member| crew_member["job"] == "Director" }
          if director
            director_name = director["name"]
            names = director_name.split(" ", 2)
            first_name = names[0]
            last_name = names[1] || ""
            
            # Try to find existing director
            existing_director = Director.where("LOWER(first_name) LIKE ? AND LOWER(last_name) LIKE ?", 
                                              "%#{first_name.downcase}%", "%#{last_name.downcase}%").first
            
            # Create new director if not found
            if existing_director.nil?
              existing_director = Director.create(
                first_name: first_name,
                last_name: last_name
              )
              flash.now[:notice] = flash.now[:notice].to_s + " Created new director: #{director_name}."
            end
            
            @movie.director_id = existing_director.id if existing_director.persisted?
          end
        end
        
        # Save poster path for display in the view and for later use
        if movie_details["poster_path"]
          @poster_path = movie_details["poster_path"]
          session[:poster_path] = @poster_path
        end
        
        # Show success message
        flash.now[:notice] = "Found details for: #{@movie.title}" + (flash.now[:notice].to_s.presence || "")
      else
        flash.now[:alert] = "No movies found with that title"
      end
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