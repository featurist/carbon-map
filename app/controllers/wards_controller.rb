# frozen_string_literal: true

class WardsController < ApplicationController
  def show
    @ward = Ward.find(params['id'])
    initiatives =
      Initiative.includes(parish: %i[ward]).where(
        parishes: { ward_id: @ward.id }
      )
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
