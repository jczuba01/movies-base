class TmdbService
    require 'net/http'
    require 'json'
    require 'open-uri'
  
    def initialize(api_key)
      @api_key = api_key
      @http = Net::HTTP.new("api.themoviedb.org", 443)
      @http.use_ssl = true
    end
  
    def fetch_movie_details(title)
      return nil if title.blank?
      
      search_request = Net::HTTP::Get.new("/3/search/movie?query=#{title}")
      search_request["Authorization"] = "Bearer #{@api_key}"
      
      search_response = @http.request(search_request)
      search_results = JSON.parse(search_response.body)
      
      if search_results["results"] && !search_results["results"].empty?
        movie_id = search_results["results"][0]["id"]
        
        movie_request = Net::HTTP::Get.new("/3/movie/#{movie_id}?append_to_response=credits")
        movie_request["Authorization"] = "Bearer #{@api_key}"
        
        movie_response = @http.request(movie_request)
        movie = JSON.parse(movie_response.body)
        
        movie_attributes = {
          title: movie["title"],
          description: movie["overview"],
          duration_minutes: movie["runtime"],
          origin_country: movie["production_countries"][0]["name"],
          genre_id: process_genre(movie),
          director_id: process_director(movie)
        }
        
        if movie["poster_path"]
          movie_attributes[:poster_path] = movie["poster_path"]
        end
        
        return movie_attributes
      end
      
      nil
    end
    
    private
    
    def process_genre(movie)
      return nil unless movie["genres"] && !movie["genres"].empty?
      
      genre_name = movie["genres"][0]["name"]
      genre = Genre.find_by(name: genre_name)
      
      unless genre
        genre = Genre.create(name: genre_name)
      end
      
      genre.id
    end
    
    def process_director(movie)
      return nil unless movie["credits"] && movie["credits"]["crew"]
      
      director = movie["credits"]["crew"].find { |c| c["job"] == "Director" }
      return nil unless director
      
      name_parts = director["name"].split(" ", 2)
      first_name = name_parts[0]
      last_name = name_parts[1] || ""
      
      existing_director = Director.find_by(first_name: first_name, last_name: last_name)
      
      unless existing_director
        existing_director = Director.create(first_name: first_name, last_name: last_name)
      end
      
      existing_director.id
    end
  end