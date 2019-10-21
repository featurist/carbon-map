# frozen_string_literal: true

class CreateSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :solutions do |t|
      t.string :name

      t.timestamps
    end
  end
end
