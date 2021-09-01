# frozen_string_literal: true

class InitiativeWebsite < ApplicationRecord
  validates :url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https])
  include Website

  belongs_to :initiative
end
