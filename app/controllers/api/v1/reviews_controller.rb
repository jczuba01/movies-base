class Api::V1::ReviewsController < ActionController::Base
    skip_before_action :verify_authenticity_token
    before_action :set_movie
    before_action :set_review, only: %i[ show update destroy]

    def index
        @reviews = @movie.reviews
        render json: @reviews, status: :ok
    end

    def show
        render json: @review, status: :ok
    end

    def create
        @review = @movie.reviews.build(review_params)

        if @review.save
            UpdateMovieRatingJob.perform_async(@movie.id)
            render json: @review, status: :created
        else
            render json: { errors: @review.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def update
        if @review.update(review_params)
            UpdateMovieRatingJob.perform_async(@movie.id)
            render json: @review, status: :ok
        else
            render json: { errors: @review.errors.full_messages }, status: unprocessable_entity
        end
    end

    def destroy
        @review.destroy
        UpdateMovieRatingJob.perform_async(@movie.id)
        head :no_content
    end

    private

    def set_movie
        @movie = Movie.find(params[:movie_id])
    end

    def set_review
        @review = @movie.reviews.find(params[:id])
    end

    def review_params
        params.require(:review).permit(:rating, :comment, :user_id)
    end
end
