# frozen_string_literal: true

require 'json'

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]

  def index
    @initiatives_json = Initiative.approved.to_json
    initiatives = Initiative.published
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
    @districts = District.all

    @recently_added = Initiative.published.order(created_at: :desc).take(4)
  end
end
