# frozen_string_literal: true

class AddSpecialistAdviceToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :specialist_advice, :string
  end
end
