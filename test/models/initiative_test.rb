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

  test 'display contact info if consent given' do
    initiative =
      Initiative.new(
        contact_name: 'so and so',
        contact_email: 'so@test.com',
        contact_phone: '1234',
        consent_to_share: true
      )

    public_attributes = initiative.public_attributes
    assert_equal 'so and so', public_attributes['contact_name']
    assert_equal 'so@test.com', public_attributes['contact_email']
    assert_equal '1234', public_attributes['contact_phone']
  end

  test 'do not display contact info if no consent' do
    initiative =
      Initiative.new(
        contact_name: 'so and so',
        contact_email: 'so@test.com',
        contact_phone: '1234',
        consent_to_share: false
      )

    public_attributes = initiative.public_attributes
    assert_nil public_attributes['contact_name']
    assert_nil public_attributes['contact_email']
    assert_nil public_attributes['contact_phone']
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
