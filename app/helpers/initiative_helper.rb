# frozen_string_literal: true

module InitiativeHelper
  def new_group_selected?(initiative)
    request.method != 'GET' && !initiative.lead_group.persisted?
  end
end
