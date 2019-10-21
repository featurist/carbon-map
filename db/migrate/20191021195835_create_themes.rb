# frozen_string_literal: true

class CreateThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :themes do |t|
      t.string :name
      t.references :sector, null: false, foreign_key: true

      t.timestamps
    end
  end
end
