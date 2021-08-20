# frozen_string_literal: true

class GroupWebsite < ApplicationRecord
  belongs_to :group
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  include Website
  delegate :name, prefix: true, to: :group
end
