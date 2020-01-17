# frozen_string_literal: true

module InitiativesHelper
  def themes_as_json(initiative)
    theme_map = initiative.themes.map { |initiative_theme| { theme_id: initiative_theme.theme.id } }

    theme_map.to_json
  end

  def solutions_as_json(initiative)
    solution_map =
      initiative.solutions.map do |solution_mapping|
        {
          solution_id: solution_mapping.solution.id,
          solution_class_id: solution_mapping.solution_class.id
        }
      end

    solution_map.to_json
  end
end
