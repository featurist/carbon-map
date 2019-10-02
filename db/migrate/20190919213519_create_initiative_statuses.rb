# frozen_string_literal: true

class CreateInitiativeStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :initiative_statuses do |t|
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
