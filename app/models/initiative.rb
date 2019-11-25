# frozen_string_literal: true

class Initiative < ApplicationRecord
  belongs_to :lead_group, class_name: 'Group'
  belongs_to :status, class_name: 'InitiativeStatus'
  delegate :name, prefix: true, to: :status
  delegate :name, prefix: true, to: :lead_group
  after_initialize :set_default_location
  has_many :solutions, class_name: 'InitiativeSolution', dependent: :destroy
  has_many_attached :images
  has_many :websites, class_name: 'InitiativeWebsite', dependent: :destroy
  accepts_nested_attributes_for :solutions
  accepts_nested_attributes_for :lead_group
  accepts_nested_attributes_for :websites, allow_destroy: true

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

  # rubocop:disable Metrics/MethodLength
  def self.approved
    Initiative.all.map do |initiative|
      attributes = initiative.public_attributes
      {
        location: initiative.location_attributes,
        name: initiative.name,
        group: initiative.lead_group_name,
        contactName: attributes['contact_name'],
        email: attributes['contact_email'],
        summary: initiative.summary,
        images: image_urls(initiative.images),
        status: initiative.status_name,
        solutions: map_solutions(initiative),
        timestamp: initiative.updated_at
      }
    end
  end
  # rubocop:enable Metrics/MethodLength

  def self.map_solutions(initiative)
    initiative.solutions.map do |mapped_solution|
      create_solution(mapped_solution)
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

  def self.create_solution(mapped_solution)
    {
      sector: mapped_solution.solution_class.theme.sector.name,
      theme: mapped_solution.solution_class.theme.name,
      class: mapped_solution.solution_class.name,
      solution: mapped_solution.solution.name
    }
  end

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
