class RolesController < ApplicationController
  before_action :set_parent
  before_action :set_role, only: [ :edit, :update, :destroy ]

  def new
    if @actor
      @role = @actor.roles.new
    else
      @role = @movie.roles.new
    end
  end

  def create
    if @actor
      @role = @actor.roles.new(actor_role_params)
    else
      @role = @movie.roles.new(movie_role_params)
    end

    if @role.save
      if @actor
        redirect_to @actor, notice: "Role was successfully created."
      else
        redirect_to @movie, notice: "Role was successfully created."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    params_to_use = @actor ? actor_role_params : movie_role_params

    if @role.update(params_to_use)
      if @actor
        redirect_to @actor, notice: "Role was successfully updated."
      else
        redirect_to @movie, notice: "Role was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy

    if @actor
      redirect_to @actor, notice: "Role was successfully deleted."
    else
      redirect_to @movie, notice: "Role was successfully deleted."
    end
  end

  private

  def set_parent
    if params[:actor_id]
      @actor = Actor.find(params[:actor_id])
    elsif params[:movie_id]
      @movie = Movie.find(params[:movie_id])
    end
  end

  def set_role
    if @actor
      @role = @actor.roles.find(params[:id])
    else
      @role = @movie.roles.find(params[:id])
    end
  end

  def actor_role_params
    params.require(:role).permit(:movie_id, :character_name)
  end

  def movie_role_params
    params.require(:role).permit(:actor_id, :character_name)
  end
end
