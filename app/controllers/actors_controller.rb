class ActorsController < ApplicationController
  before_action :set_actor, only: %i[ show edit update destroy]
  
  def index
    @actors = Actor.all
  end

  def show
    @roles = @actor.roles
  end

  def new
    @actor = Actor.new
  end

  def create
    @actor = Actor.new(actor_params)
    if @actor.save
      redirect_to @actor
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @actor.update(actor_params)
      redirect_to @actor
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @actor.destroy
    redirect_to actors_path
  end
  
  def create_role
    @role = @actor.roles.new(role_params)
    
    if @role.save
      redirect_to @actor, notice: "Role was successfully created."
    else
      @roles = @actor.roles
      render :show
    end
  end

  private 
  def set_actor
    @actor = Actor.find(params[:id])
  end
  
  def actor_params
    params.require(:actor).permit(:first_name, :last_name, :birth_date)
  end

  def role_params
    params.require(:role).permit(:movie_id, :character_name)
  end
end
