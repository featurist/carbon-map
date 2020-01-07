# frozen_string_literal: true

class AddRelatedInitiativesToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :related_initiatives, :string
  end
end
