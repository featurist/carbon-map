# frozen_string_literal: true

class AddCarbonSavingStrategyToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :carbon_saving_strategy, :string
    remove_column :initiatives, :carbon_saving_quantified, :boolean
  end
end
