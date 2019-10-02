# frozen_string_literal: true

class GroupGroupType < ApplicationRecord
  belongs_to :group
  belongs_to :group_type, dependent: :destroy
end
