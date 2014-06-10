class MarketsController < ApplicationController
  def index
    @markets = Market.where(active: true)
  end

  def show
    @market = Market.find(params[:id])
  end

  def new
    @market = Market.new
  end

  def edit
    @market = Market.find(params[:id])
  end

  def create
    @market = Market.new(market_parameters)

    if @market.save
      flash[:success] = "Market successfully created."
      redirect_to @market
    else
      render :new
    end
  end

  def update
    @market = Market.find(params[:id])

    if @market.update_attributes(market_parameters)
      flash[:success] = "Market successfully changed."
      redirect_to @market
    else
      render :edit
    end
  end

  def destroy
    @market = Market.find(params[:id])
    @market.destroy
    flash[:success] = "Market successfully destroyed."
    redirect_to markets_path
  end

private

  def market_parameters
    params.require(:market).permit(:market, :active)
  end

end
