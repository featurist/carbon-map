# frozen_string_literal: true

class Ward < ApplicationRecord
  belongs_to :district
  has_many :parishes, dependent: :destroy
end
