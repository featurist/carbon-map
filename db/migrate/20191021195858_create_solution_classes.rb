# frozen_string_literal: true

class CreateSolutionClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :solution_classes do |t|
      t.string :name
      t.references :theme, null: false, foreign_key: true

      t.timestamps
    end
  end
end
