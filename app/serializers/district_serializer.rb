class DistrictSerializer < ActiveModel::Serializer
  attributes :name, :region

  def region
    object.region.name
  end
end