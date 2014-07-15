class ClustersController < ApplicationController

  def index
    @clusters = Cluster.all
  end

  def show
    @cluster = Cluster.find(params[:id])
  end

  def new
    @cluster = Cluster.new
    # Create the menu items
    @fronts   = Front.all
    @statuses = Status.all
  end

  def create
    @front = Front.find(cluster_parameters[:front_id])
    @cluster = @front.clusters.new cluster_parameters.except(:front)

    if @cluster.save
      flash[:success] = "Cluster successfully created."
      redirect_to @cluster
    else
      # Fill in menus
      @fronts   = Front.all
      @statuses = Status.all
      render :new
    end
  end

  def edit
    @cluster = Cluster.find(params[:id])
    # Create the menu items
    @fronts   = Front.all
    @statuses = Status.all
  end

  def update
    @cluster = Cluster.find(params[:id])

    if @cluster.update_attributes cluster_parameters
      flash[:success] = "Cluster successfully changed."
      redirect_to @cluster
    else
     # Create the menu items
      @fronts   = Front.all
      @statuses = Status.all
      render :edit
    end
  end

  def destroy
    @cluster = Cluster.find(params[:id])
    flash[:success] = "Cluster successfuly destroyed."
    @cluster.destroy
    redirect_to clusters_path
  end

  private

    def cluster_parameters
      params.require(:cluster).permit(:name,
                                    :front_id,
                                    :status,
                                    :notes)
    end
end
