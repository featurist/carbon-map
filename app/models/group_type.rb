# frozen_string_literal: true

class GroupType < ApplicationRecord
  has_many :group_types, class_name: 'GroupGroupType', dependent: :destroy
end
