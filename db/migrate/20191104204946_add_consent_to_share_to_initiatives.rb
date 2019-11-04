# frozen_string_literal: true

class AddConsentToShareToInitiatives < ActiveRecord::Migration[6.0]
  def change
    add_column :initiatives,
               :consent_to_share,
               :bool,
               default: false, null: false
    remove_column :initiatives, :gdpr, :bool
    remove_column :initiatives, :gdpr_email_verified, :bool
  end
end
