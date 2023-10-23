class PlacesController < ApplicationController
  def index
  end

  def show
    results = Rails.cache.read session[:city]
    results.each do |place|
      @place = place if place.id == params[:id]
    end
    @place
  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    session[:city] = params[:city]
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index, status: 418
    end
  end
end
