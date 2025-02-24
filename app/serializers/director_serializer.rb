class DirectorSerializer
    def initialize(director)
        @director = director
    end

    def serialize
        {
            id: @director.id,
            first_name: @director.first_name,
            last_name: @director.last_name
        }
    end
end