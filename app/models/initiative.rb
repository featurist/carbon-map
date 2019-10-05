# frozen_string_literal: true

class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
  delegate :name, prefix: true, to: :status
end
