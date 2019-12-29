# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
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

  def update_location_from_postcode
    postcodes_url = "https://api.postcodes.io/postcodes/#{postcode}"
    json_response = Net::HTTP.get(URI(postcodes_url))
    location = JSON.parse(json_response)['result']
    assign_attributes(
      parish: location['parish'],
      ward: location['admin_ward'],
      district: location['admin_district'],
      county: location['admin_county'],
      region: location['region']
    )
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def self.approved
    Initiative.all.map do |initiative|
      attributes = initiative.public_attributes
      {
        location: initiative.location_attributes,
        name: initiative.name,
        group: initiative.lead_group_name,
        contactName: attributes['contact_name'],
        contactEmail: attributes['contact_email'],
        contactPhone: attributes['contact_phone'],
        summary: initiative.summary,
        images: image_urls(initiative.images),
        websites: website_urls(initiative.websites),
        status: initiative.status_name,
        solutions: map_solutions(initiative),
        themes: map_themes(initiative),
        timestamp: initiative.updated_at
      }
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def self.map_solutions(initiative)
    initiative.solutions.map do |mapped_solution|
      create_solution(mapped_solution)
    end
  end

  def self.map_themes(initiative)
    initiative.themes.map do |mapped_solution|
      {
        sector: mapped_solution.theme.sector.name,
        theme: mapped_solution.theme.name
      }
    end
  end

  def self.image_urls(images)
    images.map do |image|
      Rails.application.routes.url_helpers.rails_representation_path(
        image.variant(resize_to_limit: [200, 200]),
        only_path: true
      )
    end
  end

  def self.website_urls(websites)
    websites.map(&:website)
  end

  def self.create_solution(mapped_solution)
    {
      sector: mapped_solution.solution_class.theme.sector.name,
      theme: mapped_solution.solution_class.theme.name,
      class: mapped_solution.solution_class.name,
      solution: mapped_solution.solution.name
    }
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
# rubocop:enable Metrics/ClassLength
