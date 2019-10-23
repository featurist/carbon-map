# frozen_string_literal: true

class SolutionClass < ApplicationRecord
  belongs_to :theme
  delegate :name, to: :theme, prefix: true
end
