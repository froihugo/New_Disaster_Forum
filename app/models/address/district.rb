class Address::District < ApplicationRecord
  validates :name, presence: true
  validates :code, uniqueness: true

  belongs_to :region
  belongs_to :province
  has_many :city_municipalities
end