# frozen_string_literal: true

require 'uk_postcode'

class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
  delegate :name, prefix: true, to: :status
  delegate :name, prefix: true, to: :lead_group
  after_initialize :set_default_location
  has_many :solutions, class_name: 'InitiativeSolution', dependent: :destroy
  has_many :themes, class_name: 'InitiativeTheme', dependent: :destroy
  has_many_attached :images
  has_many :websites, class_name: 'InitiativeWebsite', dependent: :destroy
  accepts_nested_attributes_for :solutions
  accepts_nested_attributes_for :themes
  accepts_nested_attributes_for :lead_group
  accepts_nested_attributes_for :websites, allow_destroy: true
  validates :name,
            :summary,
            :status,
            :contact_name,
            :contact_email,
            :contact_phone,
            :lead_group,
            presence: true

  validate :at_least_one_solution_or_theme
  validate :validate_postcode

  def validate_postcode
    ukpc = UKPostcode.parse(postcode)
    errors['postcode'] << 'not recognised as a UK postcode' unless ukpc.full_valid?
  end

  def postcode=(str)
    super UKPostcode.parse(str).to_s
  end

  def at_least_one_solution_or_theme
    errors.add(:solution, 'at least one equired') if solutions.empty? && themes.empty?
  end

  def set_default_location
    self.latitude ||= 51.742
    self.longitude ||= -2.222
  end

  def public_attributes
    if consent_to_share
      attributes
    else
      attributes.except('contact_name', 'contact_email', 'contact_phone')
    end
  end

  def fetch_location
    postcodes_url = "https://api.postcodes.io/postcodes/#{postcode.delete(' ')}"
    json_response = Net::HTTP.get(URI(postcodes_url))
    JSON.parse(json_response)['result']
  end

  def update_location_from_postcode
    location = fetch_location
    return unless location

    assign_attributes(
      parish: location['parish'],
      ward: location['admin_ward'],
      district: location['admin_district'],
      county: location['admin_county'],
      region: location['region']
    )
  end

  def self.approved
    Initiative.all.map(&:to_public_initiative)
  end

  def to_public_initiative
    PublicInitiative.new(self)
  end

  def location
    [parish, ward, district, county, region].join(', ')
  end

  # rubocop:disable Metrics/MethodLength
  def location_attributes
    {
      parish: parish,
      ward: ward,
      district: district,
      county: county,
      region: region,
      postcode: postcode,
      latlng: {
        # "Down to Earth Stroud, PO Box 427, Stonehouse, Gloucestershire, GL6 1JG",
        lat: latitude,
        lng: longitude
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
