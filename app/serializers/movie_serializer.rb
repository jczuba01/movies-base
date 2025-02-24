class MovieSerializer
    def initialize(movie)
        @movie = movie
    end

    def serialize
        {
            id: @movie.id,
            title: @movie.title,
            description: @movie.description,
            duration_minutes: @movie.duration_minutes,
            created_at: @movie.created_at,
            updated_at: @movie.updated_at,
            average_rating: @movie.average_rating,
            genre: GenreSerializer.new(@movie.genre).serialize,
            director: DirectorSerializer.new(@movie.director).serialize

        }
    end
    
    def to_json
        serialize.to_json
    end
end