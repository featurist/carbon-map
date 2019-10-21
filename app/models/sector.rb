# frozen_string_literal: true

class Sector < ApplicationRecord
  has_many :themes, dependent: :destroy
end
