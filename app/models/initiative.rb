# frozen_string_literal: true

require 'uk_postcode'

# rubocop:disable Metrics/ClassLength
class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
  belongs_to :parish
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
  accepts_nested_attributes_for :websites, allow_destroy: true, reject_if: :website_empty?
  validates :name,
            :description_what,
            :description_how,
            :description_further_information,
            :status,
            :contact_name,
            :contact_email,
            :contact_phone,
            :lead_group,
            presence: true

  validate :at_least_one_solution_or_theme
  validate :validate_postcode

  def website_empty?(attributes)
    attributes['url'].blank?
  end

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

    create_location(location)
  end

  def create_location(location)
    region = Region.find_or_create_by(name: location['region'])
    county =
      County.find_or_create_by(name: location['admin_county'], region: region)
    district =
      District.find_or_create_by(
        name: location['admin_district'], county: county
      )
    ward =
      Ward.find_or_create_by(name: location['admin_ward'], district: district)
    self.parish = Parish.find_or_create_by(name: location['parish'], ward: ward)
  end

  def self.approved
    Initiative.all.map(&:to_public_initiative)
  end

  def to_public_initiative
    PublicInitiative.new(self)
  end

  delegate :ward, to: :parish

  delegate :district, to: :ward

  delegate :county, to: :district

  delegate :region, to: :county

  def location
    return unless parish

    [parish.name, ward.name, district.name, county.name, region.name].join(', ')
  end

  # rubocop:disable Metrics/MethodLength
  def location_attributes
    {
      parish: parish.name,
      ward: ward.name,
      district: district.name,
      county: county.name,
      region: region.name,
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
# rubocop:enable Metrics/ClassLength
