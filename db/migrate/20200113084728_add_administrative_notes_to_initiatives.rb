# frozen_string_literal: true

class AddAdministrativeNotesToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :administrative_notes, :string
  end
end
