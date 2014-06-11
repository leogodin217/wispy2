class PipesController < ApplicationController
  def index
    @pipes = Pipe.where(active: true)
  end

  def show
    @pipe = Pipe.find(params[:id])
  end

  def new
    @pipe = Pipe.new
  end

  def edit
    @pipe = Pipe.find(params[:id])
  end

  def create
    @pipe = Pipe.new(pipe_parameters)

    if @pipe.save
      flash[:success] = "Pipe successfully created."
      redirect_to @pipe
    else
      render :new
    end
  end

  def update
    @pipe = Pipe.find(params[:id])

    if @pipe.update_attributes(pipe_parameters)
      flash[:success] = "Pipe successfully changed."
      redirect_to @pipe
    else
      render :edit
    end
  end

  def destroy
    @pipe = Pipe.find(params[:id])
    @pipe.destroy
    flash[:success] = "Pipe successfully destroyed."
    redirect_to pipes_path
  end

private

  def pipe_parameters
    params.require(:pipe).permit(:pipe, :active)
  end

end
