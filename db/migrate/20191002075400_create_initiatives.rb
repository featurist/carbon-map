class CreateInitiatives < ActiveRecord::Migration[6.0]
  def change
    create_table :initiatives do |t|
      t.string :name
      t.string :summary
      t.string :image_url
      t.integer :anticipated_carbon_saving
      t.string :locality
      t.string :location
      t.string :alternative_solution_name
      t.references :lead_group, null: false, foreign_key: { to_table: :groups }
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :partner_groups_role
      t.references :status, null: false, foreign_key: { to_table: :initiative_statuses }
      t.boolean :gdpr
      t.boolean :gdpr_email_verified

      t.timestamps
    end
  end
end
