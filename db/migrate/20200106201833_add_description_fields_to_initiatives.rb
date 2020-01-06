# frozen_string_literal: true

class AddDescriptionFieldsToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :description_what, :string
    add_column :initiatives, :description_how, :string
    rename_column :initiatives, :summary, :description
  end
end
