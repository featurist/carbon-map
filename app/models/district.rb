# frozen_string_literal: true

class District < ApplicationRecord
  belongs_to :county
end
