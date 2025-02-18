class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie

  after_save :update_movie_average_rating
  after_destroy :update_movie_average_rating

  def update_movie_average_rating
    movie.update(average_rating: movie.reviews.average(:rating).to_f.round(2))
  end

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end