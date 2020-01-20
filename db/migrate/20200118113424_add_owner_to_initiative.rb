# frozen_string_literal: true

class AddOwnerToInitiative < ActiveRecord::Migration[6.0]
  def change
    add_reference :initiatives, :owner, null: true, references: :users
    Initiative.all.each do |initiative|
      owner = initiative.lead_group.owner
      initiative.update(owner: owner)
    end
  end
end
