class Movie < ApplicationRecord
    belongs_to :genre
    belongs_to :director
    has_many :reviews
    has_one_attached :cover
end
