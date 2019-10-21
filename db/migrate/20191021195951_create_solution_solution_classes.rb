# frozen_string_literal: true

class CreateSolutionSolutionClasses < ActiveRecord::Migration[6.0]
  def change
    create_table :solution_solution_classes do |t|
      t.references :solution, null: false, foreign_key: true
      t.references :solution_class, null: false, foreign_key: true

      t.timestamps
    end
  end
end
