# frozen_string_literal: true

class InitiativeSolution < ApplicationRecord
  belongs_to :solution
  belongs_to :solution_class
  belongs_to :initiative
end
