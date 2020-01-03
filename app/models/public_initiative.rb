# frozen_string_literal: true

# The publicly available data of an initiative
class PublicInitiative
  include ActionView::Helpers::DateHelper
  delegate :name, :summary, to: :@initiative

  def initialize(initiative)
    @initiative = initiative
  end

  def location
    @initiative.location_attributes
  end

  def group
    @initiative.lead_group_name
  end

  def timestamp
    @initiative.updated_at
  end

  def contact_name
    @initiative.public_attributes['contact_name']
  end

  def contact_email
    @initiative.public_attributes['contact_email']
  end

  def contact_phone
    @initiative.public_attributes['contact_phone']
  end

  def status
    @initiative.status_name
  end

  def solutions
    @initiative.solutions.map do |mapped_solution|
      create_solution(mapped_solution)
    end
  end

  def themes
    @initiative.themes.map do |mapped_solution|
      {
        sector: mapped_solution.theme.sector.name,
        theme: mapped_solution.theme.name
      }
    end
  end

  def images
    @initiative.images.map do |image|
      Rails.application.routes.url_helpers.rails_representation_path(
        image.variant(resize_to_limit: [200, 200]),
        only_path: true
      )
    end
  end

  def websites
    @initiative.websites.map(&:website)
  end

  def last_updated
    time_ago_in_words(timestamp) + ' ago'
  end

  def href
    Rails.application.routes.url_helpers.initiative_path(@initiative)
  end

  # rubocop:disable Metrics/MethodLength
  def as_json(_options = {})
    {
      'name': name,
      'summary': summary,
      'group': group,
      'location': location,
      'contactName': contact_name,
      'contactEmail': contact_email,
      'contactPhone': contact_phone,
      'status': status,
      'solutions': solutions,
      'themes': themes,
      'websites': websites,
      'images': images,
      'timestamp': timestamp,
      'lastUpdated': last_updated,
      'href': href
    }
  end
  # rubocop:enable Metrics/MethodLength

  private

  def create_solution(mapped_solution)
    {
      sector: mapped_solution.solution_class.theme.sector.name,
      theme: mapped_solution.solution_class.theme.name,
      class: mapped_solution.solution_class.name,
      solution: mapped_solution.solution.name
    }
  end
end