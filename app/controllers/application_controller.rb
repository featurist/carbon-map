# frozen_string_literal: true

class ApplicationController < ActionController::Base
  default_form_builder SuitFormBuilder
  before_action :store_user_location!, if: :storable_location?
  before_action :authenticate_user!

  private

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath) unless request.fullpath.include? animation_path
  end
end
