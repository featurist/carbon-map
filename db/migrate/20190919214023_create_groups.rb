# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[6.0]
  def change
    create_table :groups do |t|
      t.string :name
      t.string :abbreviation
      t.string :opening_hours
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.boolean :gdpr
      t.boolean :gdpr_email_verified
      t.references :owner

      t.timestamps
    end
  end
end
