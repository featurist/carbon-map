# frozen_string_literal: true

class CreateGroupGroupTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :group_group_types do |t|
      t.references :group, null: false, foreign_key: true
      t.references :group_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
