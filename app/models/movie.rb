class Movie < ApplicationRecord
    belongs_to :genre
    belongs_to :director
    has_many :reviews
    has_many :roles
    has_many :actors, through: :roles
    has_one_attached :cover

    validates :title, presence: true
    validates :duration_minutes, presence: true

    def self.ransackable_attributes(auth_object = nil)
        ["title", "id", "genre_id", "director_id", "duration_minutes", "origin_country"]
    end

    def self.ransackable_associations(auth_object = nil)
        ["director", "genre"]
    end
end
