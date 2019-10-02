# frozen_string_literal: true

class CreateGroupWebsites < ActiveRecord::Migration[6.0]
  def change
    create_table :group_websites do |t|
      t.string :website
      t.references :group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
