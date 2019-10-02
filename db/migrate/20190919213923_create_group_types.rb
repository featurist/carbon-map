# frozen_string_literal: true

class CreateGroupTypes < ActiveRecord::Migration[6.0]
  def change
    create_table :group_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
