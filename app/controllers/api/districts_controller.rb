class Api::DistrictsController < ApplicationController
  def index
    region = Address::Districts.find(params[:region_id])
    districts = region.districts
    render json: provinces, each_serializer: ProvinceSerializer
  end
end