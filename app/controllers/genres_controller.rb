class GenresController < ApplicationController
  before_action :authenticate_user!
  before_action :set_genre, only: [:show, :edit, :update, :destroy]

  def index
    @genres = current_user.genres
  end

  def show
  end

  def new
    @genre = current_user.genres.build
  end

  def create
    @genre = current_user.genres.build(genre_params)
    if @genre.save
      redirect_to @genre
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @genre.update(genre_params)
      redirect_to @genre
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @genre.destroy
    redirect_to genres_path
  end

  private
    def set_genre
      @genre = current_user.genres.find(params[:id])
    end

    def genre_params
      params.require(:genre).permit(:name)
    end
end