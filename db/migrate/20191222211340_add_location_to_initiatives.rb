# frozen_string_literal: true

class AddLocationToInitiatives < ActiveRecord::Migration[6.0]
  def change
    remove_column :initiatives, :locality, :string
    remove_column :initiatives, :location, :string

    add_column :initiatives, :postcode, :string
    add_column :initiatives, :parish, :string
    add_column :initiatives, :ward, :string
    add_column :initiatives, :district, :string
    add_column :initiatives, :county, :string
    add_column :initiatives, :region, :string
  end
end
