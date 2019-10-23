# frozen_string_literal: true

require 'json'

class HomeController < ApplicationController
  def index
    @initiatives_json = Initiative.approved.to_json
    @sectors = Sector.all
  end
end
