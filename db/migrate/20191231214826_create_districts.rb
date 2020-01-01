# frozen_string_literal: true

class CreateDistricts < ActiveRecord::Migration[6.0]
  def change
    create_table :districts do |t|
      t.string :name
      t.belongs_to :county

      t.timestamps
    end
  end
end
