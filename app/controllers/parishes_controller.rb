# frozen_string_literal: true

class ParishesController < ApplicationController
  def show
    @parish = Parish.find(params['id'])
    @ward = @parish.ward
    initiatives = Initiative.where(parish_id: @parish.id)
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
