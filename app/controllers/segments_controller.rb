class SegmentsController < ApplicationController
  def index
    @segments = Segment.where(active: true)
  end

  def show
    @segment = Segment.find(params[:id])
  end

  def new
    @segment = Segment.new
  end

  def edit
    @segment = Segment.find(params[:id])
  end

  def create
    @segment = Segment.new(segment_parameters)

    if @segment.save
      flash[:success] = "Segment successfully created."
      redirect_to @segment
    else
      render :new
    end
  end

  def update
    @segment = Segment.find(params[:id])

    if @segment.update_attributes(segment_parameters)
      flash[:success] = "Segment successfully changed."
      redirect_to @segment
    else
      render :edit
    end
  end

  def destroy
    @segment = Segment.find(params[:id])
    @segment.destroy
    flash[:success] = "Segment successfully destroyed."
    redirect_to segments_path
  end

private

  def segment_parameters
    params.require(:segment).permit(:segment, :active)
  end

end
