# frozen_string_literal: true

module InitiativesHelper
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
