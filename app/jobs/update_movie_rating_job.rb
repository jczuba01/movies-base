class UpdateMovieRatingJob
  include Sidekiq::Job

  def perform(movie_id)
    movie = Movie.find(movie_id)
    average = movie.reviews.average(:rating).to_f.round(2)
    movie.update(average_rating: average)
  end
end
