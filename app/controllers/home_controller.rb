# frozen_string_literal: true

require 'json'

class HomeController < ApplicationController
  def index
    @initiatives_json = Initiative.approved.to_json
    initiatives = Initiative.all
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
  end
end
