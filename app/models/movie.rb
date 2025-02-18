class Movie < ApplicationRecord
    belongs_to :genre
    belongs_to :director
    has_many :reviews
end
