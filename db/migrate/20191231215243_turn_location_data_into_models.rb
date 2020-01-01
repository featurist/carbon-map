# frozen_string_literal: true

class TurnLocationDataIntoModels < ActiveRecord::Migration[6.0]
  def change
    remove_column :initiatives, :parish, :string
    remove_column :initiatives, :ward, :string
    remove_column :initiatives, :district, :string
    remove_column :initiatives, :county, :string
    remove_column :initiatives, :region, :string

    add_belongs_to :initiatives, :parish, null: true
  end
end
