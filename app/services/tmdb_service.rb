class TmdbService
    require "net/http"
    require "json"
    require "open-uri"

    def initialize(title)
      @title = title
      @api_key = Rails.application.credentials.tmdb[:api_key]
      @http = Net::HTTP.new("api.themoviedb.org", 443)
      @http.use_ssl = true
    end

    def fetch_movie_details
      return nil if @title.blank?

      movie_data = search_and_fetch_movie
      return nil unless movie_data

      movie = Movie.new(
        title: movie_data["title"],
        description: movie_data["overview"],
        duration_minutes: movie_data["runtime"],
        origin_country: movie_data["production_countries"][0]["name"],
        genre_id: process_genre(movie_data),
        director_id: process_director(movie_data)
      )

      movie
    end

    def fetch_poster_path
      return nil if @title.blank?

      movie_data = search_and_fetch_movie
      return nil unless movie_data

      movie_data["poster_path"]
    end

    private

    def search_and_fetch_movie
      search_request = Net::HTTP::Get.new("/3/search/movie?query=#{@title}")
      search_request["Authorization"] = "Bearer #{@api_key}"

      search_response = @http.request(search_request)
      search_results = JSON.parse(search_response.body)

      movie_id = search_results["results"][0]["id"]

      movie_request = Net::HTTP::Get.new("/3/movie/#{movie_id}?append_to_response=credits")
      movie_request["Authorization"] = "Bearer #{@api_key}"

      movie_response = @http.request(movie_request)
      JSON.parse(movie_response.body)
    end

    def process_genre(movie)
      genre_name = movie["genres"][0]["name"]
      genre = Genre.find_by(name: genre_name)

      unless genre
        genre = Genre.create(name: genre_name)
      end

      genre.id
    end

    def process_director(movie)
      director = movie["credits"]["crew"].find { |c| c["job"] == "Director" }
      return nil unless director

      name_parts = director["name"].split(" ", 2)
      first_name = name_parts[0]
      last_name = name_parts[1] || ""

      exsisting_director = Director.find_by(first_name: first_name, last_name: last_name)

      unless exsisting_director
        exsisting_director = Director.create(first_name: first_name, last_name: last_name)
      end

      exsisting_director.id
    end
end
