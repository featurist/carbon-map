# frozen_string_literal: true

class CreateWards < ActiveRecord::Migration[6.0]
  def change
    create_table :wards do |t|
      t.string :name
      t.belongs_to :district

      t.timestamps
    end
  end
end
