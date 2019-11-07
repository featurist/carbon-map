class CreateInitiativeWebsites < ActiveRecord::Migration[6.0]
  def change
    create_table :initiative_websites do |t|
      t.string :website
      t.references :initiative, null: false, foreign_key: true

      t.timestamps
    end
  end
end
