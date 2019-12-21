# frozen_string_literal: true

class RemoveOpeningHoursFromGroups < ActiveRecord::Migration[6.0]
  def change
    remove_column :groups, :opening_hours, :string
  end
end
