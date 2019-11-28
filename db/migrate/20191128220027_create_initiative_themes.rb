# frozen_string_literal: true

class CreateInitiativeThemes < ActiveRecord::Migration[6.0]
  def change
    create_table :initiative_themes do |t|
      t.references :initiative, null: false, foreign_key: true
      t.references :theme, null: false, foreign_key: true

      t.timestamps
    end
  end
end
