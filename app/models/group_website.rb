# frozen_string_literal: true

class GroupWebsite < ApplicationRecord
  belongs_to :group
  validates :website, format: URI.regexp(%w[http https])
  include Website
  delegate :name, prefix: true, to: :group
end
