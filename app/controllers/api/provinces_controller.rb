class Api::ProvincesController < ApplicationController
  def index
    region = Address::Province.find(params[:region_id])
    provinces = region.provinces
    render json: provinces, each_serializer: ProvinceSerializer
  end
end