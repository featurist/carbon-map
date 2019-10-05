# frozen_string_literal: true

class GroupWebsite < ApplicationRecord
  belongs_to :group
  delegate :name, prefix: true, to: :group
end
