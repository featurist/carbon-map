# frozen_string_literal: true

class InitiativeTheme < ApplicationRecord
  belongs_to :initiative
  belongs_to :theme
end
