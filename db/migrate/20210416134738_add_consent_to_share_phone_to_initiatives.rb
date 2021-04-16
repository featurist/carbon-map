# frozen_string_literal: true

class AddConsentToSharePhoneToInitiatives < ActiveRecord::Migration[6.0]
  def change
    rename_column :initiatives, :consent_to_share, :consent_to_share_email
    add_column :initiatives, :consent_to_share_phone, :boolean

    reversible do |dir|
      dir.up do
        execute 'update initiatives set consent_to_share_phone = consent_to_share_email'
      end
    end
  end
end
