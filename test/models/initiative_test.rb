# frozen_string_literal: true

require 'test_helper'

class InitiativeTest < ActiveSupport::TestCase
  test 'approved json' do
    initiatives =
      Initiative.approved.map do |initiative|
        initiative.extract!(:timestamp)
        initiative
      end
    assert_equal expected_initiative_attributes, initiatives
  end

  # rubocop:disable Metrics/MethodLength
  def expected_initiative_attributes
    [
      {
        location: {
          name: 'Stonehouse',
          address: 'GL6 1JG',
          latlng: { lat: 51.749252, lng: -2.283587 }
        },
        name: 'The Fruit Exchange',
        group: 'Down to Earth Stroud',
        contactName: 'No name',
        email: 'info@downtoearthstroud.co.uk',
        summary:
          'The Fruit Exchange connects food outlets with people who have surplus fruit or veg.',
        status: 'Operational',
        solutions: [],
        images: []
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
