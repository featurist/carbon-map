class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
end
