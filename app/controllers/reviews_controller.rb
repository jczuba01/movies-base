class ReviewsController < ApplicationController
  before_action :set_movie
  before_action :set_review, only: [:update, :destroy]

  def create
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
    
    if @review.save
      update_movie_rating
      redirect_to @movie, notice: 'Review was successfully created.'
    else
      redirect_to @movie, alert: 'Error creating review.'
    end
  end

  def update 
    if @review.update(review_params)
      update_movie_rating
      redirect_to @movie, notice: 'Review was successfully updated.'
    else
      redirect_to @movie, alert: 'Error updating review.'
    end
  end

  def destroy
    if @review.destroy
      update_movie_rating
      redirect_to @movie, notice: 'Review was successfully deleted.'
    else
      redirect_to @movie, alert: 'Error deleting review.'
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_review
    @review = @movie.reviews.find(params[:id])
  end

  def update_movie_rating
    average = @movie.reviews.average(:rating).to_f.round(2)
    @movie.update(average_rating: average)
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end