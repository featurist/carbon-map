# frozen_string_literal: true

module InitiativeHelper
  def new_group_selected?(initiative)
    request.method != 'GET' && !initiative.lead_group.persisted? &&
      !initiative.lead_group.empty?
  end

  def initiative_step(number, current, title:, next_text:, &block)
    return unless current == number

    render('partials/initiative_step', title: title, current: current, next_text: next_text, step: number, &block)
  end
end
