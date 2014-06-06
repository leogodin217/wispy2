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
end
