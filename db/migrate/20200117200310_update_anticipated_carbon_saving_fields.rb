# frozen_string_literal: true

class UpdateAnticipatedCarbonSavingFields < ActiveRecord::Migration[6.0]
  def change
    rename_column :initiatives, :anticipated_carbon_saving, :carbon_saving_amount
    add_column :initiatives, :carbon_saving_anticipated, :boolean, default: false, null: false
    add_column :initiatives, :carbon_saving_quantified, :boolean, default: false, null: false
  end
end
