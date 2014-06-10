class FrontsController < ApplicationController

  def index
    @fronts = Front.all
  end

  def show
    @front = Front.find(params[:id])
  end

  def new
    @front = Front.new
  end

  def create
    @front = Front.new front_parameters

    if @front.save
      flash[:success] = "Front successfully created."
      redirect_to @front
    else
      render :new
    end
  end

  def edit  
    @front = Front.find(params[:id])
  end

  def update
    @front = Front.find(params[:id])

    if @front.update_attributes front_parameters
      redirect_to @front
    else
      render :edit
    end
  end

  private

    def front_parameters
      params.require(:front).permit(:market,
                                    :segment,
                                    :site,
                                    :app_layer,
                                    :pipe,
                                    :status,
                                    :notes)
    end
end
