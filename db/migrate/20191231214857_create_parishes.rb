# frozen_string_literal: true

class CreateParishes < ActiveRecord::Migration[6.0]
  def change
    create_table :parishes do |t|
      t.string :name
      t.belongs_to :ward

      t.timestamps
    end
  end
end
