# frozen_string_literal: true

class AddPublicationStatusToInitiative < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives, :publication_status, :string
    add_index :initiatives, :publication_status

    reversible do |dir|
      dir.up do
        ActiveRecord::Base.connection.execute("update initiatives set publication_status = 'published'")
      end
    end

    change_column_null :initiatives, :lead_group_id, true
    change_column_null :initiatives, :status_id, true
  end
end
