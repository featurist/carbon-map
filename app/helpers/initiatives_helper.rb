# frozen_string_literal: true

module InitiativesHelper
  def publication_statuses
    statuses = Initiative.publication_statuses.to_h
    statuses.reject! { |status| %w[rejected archived].include?(status) } unless user_is_admin?
    statuses.map do |key, value|
      [value.titlecase, key]
    end
  end
end
