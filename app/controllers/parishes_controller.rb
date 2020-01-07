# frozen_string_literal: true

class ParishesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    @parish = Parish.find(params['id'])
    @ward = @parish.ward
    @district = @ward.district
    initiatives = Initiative.where(parish_id: @parish.id)
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
