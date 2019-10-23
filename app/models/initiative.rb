# frozen_string_literal: true

class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
  delegate :name, prefix: true, to: :status
  delegate :name, prefix: true, to: :lead_group
  after_initialize :set_default_location
  has_many :solutions, class_name: 'InitiativeSolution', dependent: :destroy
  accepts_nested_attributes_for :solutions

  def set_default_location
    self.latitude ||= 51.742
    self.longitude ||= -2.222
  end

  # rubocop:disable Metrics/MethodLength
  def self.approved
    initiatives = Initiative.all

    initiatives.map do |initiative|
      {
        location: initiative.location_attributes,
        name: initiative.name,
        group: initiative.lead_group_name,
        contactName: initiative.contact_name,
        email: initiative.contact_email,
        # "website": "http://www.downtoearthstroud.co.uk/the-fruit-exchange1/",
        summary: initiative.summary,
        status: initiative.status_name,
        "sector": 'Food',
        "theme": 'Community food production and Food Waste',
        "solution": 'Produce sharing',
        # "notes": "They've mapped companies taking part in sharing the produce!",
        timestamp: initiative.updated_at
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def location_attributes
    {
      name: locality,
      address: location,
      latlng: {
        # "Down to Earth Stroud, PO Box 427, Stonehouse, Gloucestershire, GL6 1JG",
        lat: latitude,
        lng: longitude
      }
    }
  end
end
