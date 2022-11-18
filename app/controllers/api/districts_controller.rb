class Api::DistrictsController < ApplicationController
  def index
    region = Address::Districts.find(params[:region_id])
    districts = region.districts
    render json: districts, each_serializer: DistrictSerializer
  end
end