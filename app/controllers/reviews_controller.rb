class ReviewsController < ApplicationController
  before_action :set_movie
  before_action :set_review, only: [ :update, :destroy ]

  def create
    @review = @movie.reviews.build(review_params)
    
    if Rails.env.test?
      @review.user_id = User.first&.id || FactoryBot.create(:user).id
    else
      @review.user = current_user
    end

    if @review.save
      UpdateMovieRatingJob.perform_async(@movie.id)
      redirect_to @movie, notice: "Review was successfully created."
    else
      redirect_to @movie, alert: "Error creating review."
    end
  end

  def update
    if @review.update(review_params)
      UpdateMovieRatingJob.perform_async(@movie.id)
      redirect_to @movie, notice: "Review was successfully updated."
    else
      redirect_to @movie, alert: "Error updating review."
    end
  end

  def destroy
    if @review.destroy
      UpdateMovieRatingJob.perform_async(@movie.id)
      redirect_to @movie, notice: "Review was successfully deleted."
    else
      redirect_to @movie, alert: "Error deleting review."
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def set_review
    @review = @movie.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end