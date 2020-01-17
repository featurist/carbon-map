# frozen_string_literal: true

class AnimationsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]
  layout false

  def show
    initiatives = Initiative.all
    @map_data = MapData.new(initiatives)
  end
end
