# frozen_string_literal: true

class CreateInitiativeSolutions < ActiveRecord::Migration[6.0]
  def change
    create_table :initiative_solutions do |t|
      t.references :solution, null: false, foreign_key: true
      t.references :solution_class, null: false, foreign_key: true
      t.references :initiative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
