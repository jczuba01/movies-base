class Movie < ApplicationRecord
    belongs_to :genre
    belongs_to :director
    belongs_to :user
end
