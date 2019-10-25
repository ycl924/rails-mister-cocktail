require 'net/https'
require 'uri'
require 'json'

class CocktailsController < ApplicationController
  before_action :set_item, only: [:show, :set_picture, :destroy]

  def new
    @cocktail = Cocktail.new
  end

  def create
    @cocktail = Cocktail.new(cocktail_params)
    @cocktail.save!
    redirect_to cocktail_path(@cocktail)
  end

  def index
    if params[:query].present?
      @query = params[:query]
      pre_cocktails = Cocktail.where("name ILIKE '%#{@query}%'")
      ingredient_ids = Ingredient.where("name ILIKE '%#{@query}%'").pluck(:id)
      doses = Dose.where(ingredient_id: ingredient_ids).pluck(:cocktail_id)
      post_cocktails = Cocktail.where(id: doses)
      @cocktails = pre_cocktails + post_cocktails
    else
      @cocktails = Cocktail.all
    end
  end

  def show
   @doses = Dose.where(cocktail_id: @cocktail.id)
   @image = fetch_pictures_bing
   @icon = ""
  end

  def destroy
    @cocktail.destroy
    redirect_to cocktails_path
  end

  def fetch_pictures_pixabay
    baseUrl = 'https://pixabay.com/api/?'
    apiKey = 'key=14048438-c598fadb744a8f37902b17409'
    query = '&q=cocktail+'
    json = open(baseUrl+apiKey+query+@cocktail.name).read
    parsed = JSON.parse(json)
    images = []
    parsed["hits"][0..5].each { |pic| images << pic["largeImageURL"]}
    return images
  end

  def fetch_pictures_bing
    apiKey = '480c043bad654986bf454766661b0154'
    endpoint = 'https://bing-search-lewagon.cognitiveservices.azure.com/bing/v7.0/images/search'
    query = "cocktail #{@cocktail.name}"
    uri = URI(endpoint + "?q=" + URI.escape(query))
    request = Net::HTTP::Get.new(uri)
    request['Ocp-Apim-Subscription-Key'] = apiKey
    response = Net::HTTP.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(request)
    end
    response.each_header do |key, value|
    # header names are lowercased
      if key.start_with?("bingapis-") or key.start_with?("x-msedge-") then
        puts key + ": " + value
      end
    end
    parsed_json = JSON.parse(response.body)
    images = []
    parsed_json["value"][0..5].each do |result|
      images << result["contentUrl"]
    end
    return images
  end


  def set_picture
    image = params[:image]
    @cocktail.picture = image
    @cocktail.save!
    redirect_to cocktail_path(@cocktail)
  end

  private

  def set_item
    @cocktail = Cocktail.find(params[:id])
  end

  def cocktail_params
    params.require(:cocktail).permit(:name)
  end
end
