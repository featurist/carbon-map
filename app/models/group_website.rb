# frozen_string_literal: true

class GroupWebsite < ApplicationRecord
  include Website
  belongs_to :group
  delegate :name, prefix: true, to: :group
end
