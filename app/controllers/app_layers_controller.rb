class AppLayersController < ApplicationController
  def index
    @app_layers = AppLayer.where(active: true)
  end

  def show
    @app_layer = AppLayer.find(params[:id])
  end

  def new
    @app_layer = AppLayer.new
  end

  def edit
    @app_layer = AppLayer.find(params[:id])
  end

  def create
    @app_layer = AppLayer.new(app_layer_parameters)

    if @app_layer.save
      flash[:success] = "App layer successfully created."
      redirect_to @app_layer
    else
      render :new
    end
  end

  def update
    @app_layer = AppLayer.find(params[:id])

    if @app_layer.update_attributes(app_layer_parameters)
      flash[:success] = "App layer successfully changed."
      redirect_to @app_layer
    else
      render :edit
    end
  end

  def destroy
    @app_layer = AppLayer.find(params[:id])
    @app_layer.destroy
    flash[:success] = "App layer successfully destroyed."
    redirect_to app_layers_path
  end

private

  def app_layer_parameters
    params.require(:app_layer).permit(:app_layer, :active)
  end

end
