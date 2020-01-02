# frozen_string_literal: true

class Parish < ApplicationRecord
  belongs_to :ward
  has_many :initiatives, dependent: :destroy
end
