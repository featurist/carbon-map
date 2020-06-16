# frozen_string_literal: true

class DistrictsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @district = District.find(params['id'])
    initiatives =
      Initiative.published.includes(parish: %i[ward]).where(
        parishes: { wards: { district_id: @district.id } }
      )
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
