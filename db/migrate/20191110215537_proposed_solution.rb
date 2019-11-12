# frozen_string_literal: true

class ProposedSolution < ActiveRecord::Migration[6.0]
  def change
    add_column :solutions, :status, :bigint, default: 100, null: false
    add_reference :solutions, :created_by, references: :users
    add_reference :solutions, :approved_by, references: :users
    remove_column :initiatives, :alternative_solution_name, :string
  end
end
