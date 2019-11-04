# frozen_string_literal: true

class AddConsentToShareToGroups < ActiveRecord::Migration[6.0]
  def change
    add_column :groups, :consent_to_share, :bool, default: false, null: false
    remove_column :groups, :gdpr, :bool
    remove_column :groups, :gdpr_email_verified, :bool
  end
end
