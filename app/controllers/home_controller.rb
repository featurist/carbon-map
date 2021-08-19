# frozen_string_literal: true

require 'json'

class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index]
  layout 'home'

  def index
    @initiatives_json = Initiative.approved.to_json
    initiatives = Initiative.published
    @map_data = MapData.new(initiatives)
    @sectors = Sector.all
    @districts = District.all

    @recently_added = Initiative.published.order(created_at: :desc).take(4)

    show_initiatives
  end

  def show_initiatives
    current_users_initiatives = current_user&.initiatives || []
    @initiatives = if current_user&.role == 'admin'
                     Initiative.all.sort_by(&:name)
                   else
                     (Initiative.published + current_users_initiatives).uniq.sort_by(&:name)
                   end
  end
end
