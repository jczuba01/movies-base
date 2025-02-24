class GenreSerializer
    def initialize(genre)
        @genre = genre
    end

    def serialize
        {
            id: @genre.id,
            name: @genre.name
        }
    end
end