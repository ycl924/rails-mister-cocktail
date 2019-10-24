class CocktailsController < ApplicationController
  before_action :set_item, only: [:show]
  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(restaurant_params)
  end

  def index
    @cocktails = Cocktail.all
  end

  def show
  end

  private

  def set_item
    @cocktail = Cocktail.find(params[:id])
  end

  def restaurant_params
    params.require(:cocktail).permit(:name)
  end
end
