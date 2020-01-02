# frozen_string_literal: true

class District < ApplicationRecord
  belongs_to :county
  has_many :wards, dependent: :destroy
end
