# frozen_string_literal: true

class InitiativeTheme < ApplicationRecord
  belongs_to :initiative
  belongs_to :theme

  def name
    sector = theme.sector
    "#{sector.name}, #{theme.name}"
  end
end
