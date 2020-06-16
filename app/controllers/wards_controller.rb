# frozen_string_literal: true

class WardsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @ward = Ward.find(params['id'])
    initiatives =
      Initiative.published.includes(parish: %i[ward]).where(
        parishes: { ward_id: @ward.id }
      )
    @district = @ward.district
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
