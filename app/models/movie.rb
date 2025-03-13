class Movie < ApplicationRecord
    belongs_to :genre
    belongs_to :director
    has_many :reviews
    has_many :roles
    has_many :actors, through: :roles
    has_one_attached :cover

    validates :title, presence: true
    validates :duration_minutes, presence: true
end
