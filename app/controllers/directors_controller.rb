class DirectorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_director, only: [:show, :edit, :update, :destroy]

  def index
    @directors = current_user.directors
  end

  def show
  end

  def new
    @director = current_user.directors.build
  end

  def create
    @director = current_user.directors.build(director_params)
    if @director.save
      redirect_to @director
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @director.update(director_params)
      redirect_to @director
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @director.destroy
    redirect_to directors_path
  end

  private
    def set_director
      @director = current_user.directors.find(params[:id])
    end

    def director_params
      params.require(:director).permit(:first_name, :last_name, :birth_date)
    end
end