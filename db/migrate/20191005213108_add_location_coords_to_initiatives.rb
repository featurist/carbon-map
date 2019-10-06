# frozen_string_literal: true

class AddLocationCoordsToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :latitude, :float
    add_column :initiatives, :longitude, :float
  end
end
