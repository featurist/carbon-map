# frozen_string_literal: true

require 'test_helper'

class InitiativeTest < ActiveSupport::TestCase
  test 'approved json' do
    initiatives =
      Initiative.approved.map do |initiative|
        res = JSON.parse(initiative.to_json)
        res.delete('timestamp')
        res.delete('lastUpdated')
        res.delete('href')
        res.deep_symbolize_keys!
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

  test 'postcode is valid' do
    initiative = initiatives :fruit_exchange
    assert initiative.valid?

    initiative.postcode = 'invalid'
    assert_not initiative.valid?
  end

  # rubocop:disable Metrics/MethodLength
  def expected_initiative_attributes
    [
      {
        name: 'The Fruit Exchange',
        summary:
          'The Fruit Exchange connects food outlets with people who have surplus fruit or veg.',
        group: 'Down to Earth Stroud',
        location: {
          parish: 'Stroud',
          ward: 'Stroud Uplands',
          district: 'Stroud',
          county: 'Gloucestershire',
          region: 'South West',
          postcode: 'GL54UB',
          latlng: { lat: 51.749252, lng: -2.283587 }
        },
        contactName: 'No name',
        contactEmail: 'info@downtoearthstroud.co.uk',
        contactPhone: '01453 700011',
        status: 'Operational',
        solutions: [
          {
            sector: 'Energy',
            theme: 'Heating',
            class: 'Heat pumps',
            solution: 'ASHP'
          }
        ],
        themes: [],
        websites: [],
        images: []
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength
end
