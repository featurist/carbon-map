# frozen_string_literal: true

class InitiativeWebsite < ApplicationRecord
  include Website
  belongs_to :initiative
end
