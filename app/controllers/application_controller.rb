# frozen_string_literal: true

class ApplicationController < ActionController::Base
  default_form_builder SuitFormBuilder
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!, if: :requires_authentication

  private

  def requires_authentication
    ![root_path, about_path, contact_path].include?(request.path)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
