# frozen_string_literal: true

class RemoveImageUrlFromInitiatives < ActiveRecord::Migration[6.0]
  def change
    remove_column :initiatives, :image_url, :string
  end
end
