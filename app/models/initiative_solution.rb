# frozen_string_literal: true

class InitiativeSolution < ApplicationRecord
  belongs_to :solution
  belongs_to :solution_class
  belongs_to :initiative

  def name
    theme = solution_class.theme
    sector = theme.sector
    "#{sector.name} > #{theme.name} > #{solution_class.name} > #{solution.name}"
  end
end
