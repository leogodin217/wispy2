class SitesController < ApplicationController
  def index
    @sites = Site.where(active: true)
  end

  def show
    @site = Site.find(params[:id])
  end

  def new
    @site = Site.new
  end

  def edit
    @site = Site.find(params[:id])
  end

  def create
    @site = Site.new(site_parameters)

    if @site.save
      flash[:success] = "Site successfully created."
      redirect_to @site
    else
      render :new
    end
  end

  def update
    @site = Site.find(params[:id])

    if @site.update_attributes(site_parameters)
      flash[:success] = "Site successfully changed."
      redirect_to @site
    else
      render :edit
    end
  end

  def destroy
    @site = Site.find(params[:id])
    @site.destroy
    flash[:success] = "Site successfully destroyed."
    redirect_to sites_path
  end

private

  def site_parameters
    params.require(:site).permit(:site, :active)
  end

end
