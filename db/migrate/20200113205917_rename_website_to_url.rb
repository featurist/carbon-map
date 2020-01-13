# frozen_string_literal: true

class RenameWebsiteToUrl < ActiveRecord::Migration[6.0]
  def change
    rename_column :initiative_websites, :website, :url
    rename_column :group_websites, :website, :url
  end
end
