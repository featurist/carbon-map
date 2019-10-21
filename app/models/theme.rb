# frozen_string_literal: true

class Theme < ApplicationRecord
  belongs_to :sector
  has_many :solution_classes, dependent: :destroy
end
