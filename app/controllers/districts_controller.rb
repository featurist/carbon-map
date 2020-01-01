# frozen_string_literal: true

class DistrictsController < ApplicationController
  def index
    @districts = District.all
  end

  def show
    @district = District.find(params['id'])
    initiatives =
      Initiative.includes(parish: %i[ward]).where(
        parishes: { wards: { district_id: @district.id } }
      )
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
