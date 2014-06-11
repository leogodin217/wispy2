class StatusesController < ApplicationController
  def index
    @statuses = Status.where(active: true)
  end

  def show
    @status = Status.find(params[:id])
  end

  def new
    @status = Status.new
  end

  def edit
    @status = Status.find(params[:id])
  end

  def create
    @status = Status.new(status_parameters)

    if @status.save
      flash[:success] = "Status successfully created."
      redirect_to @status
    else
      render :new
    end
  end

  def update
    @status = Status.find(params[:id])

    if @status.update_attributes(status_parameters)
      flash[:success] = "Status successfully changed."
      redirect_to @status
    else
      render :edit
    end
  end

  def destroy
    @status = Status.find(params[:id])
    @status.destroy
    flash[:success] = "Status successfully destroyed."
    redirect_to statuses_path
  end

private

  def status_parameters
    params.require(:status).permit(:status, :active)
  end

end
