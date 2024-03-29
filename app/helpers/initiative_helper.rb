# frozen_string_literal: true

module InitiativeHelper
  def new_group_selected?(initiative)
    request.method != 'GET' && !initiative.lead_group.persisted? &&
      !initiative.lead_group.empty?
  end

  # rubocop:disable Metrics/ParameterLists
  def initiative_step(number, current, title:, next_text:, next_suffix_text: nil, intro_text: nil, &block)
    return unless current == number

    render('partials/initiative_step',
           title: title,
           current: current,
           next_suffix_text: next_suffix_text,
           next_text: next_text,
           intro_text: intro_text,
           step: number, &block)
  end
  # rubocop:enable Metrics/ParameterLists
end
