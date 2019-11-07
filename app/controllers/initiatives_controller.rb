# frozen_string_literal: true

class InitiativesController < ApplicationController
  before_action :set_initiative, only: %i[show edit update destroy]
  before_action :set_edit_data, only: %i[edit new create update]

  def index
    @initiatives = current_user.initiatives.all
  end

  def show; end

  def new
    @initiative = Initiative.new
  end

  def edit; end

  def create
    @initiative = Initiative.new(initiative_params)

    if check_user_belongs_to_group && @initiative.save
      redirect_to edit_initiative_path(@initiative),
                  notice: 'Initiative was successfully created.'
    else
      render :new
    end
  end

  def update
    @initiative.solutions.clear
    params = initiative_params
    images = params.delete 'images'

    if check_user_belongs_to_group && @initiative.update(params)
      @initiative.images.attach images if images
      redirect_to edit_initiative_path(@initiative),
                  notice: 'Initiative was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @initiative.destroy
    redirect_to initiatives_url,
                notice: 'Initiative was successfully destroyed.'
  end

  private

  def set_initiative
    @initiative = Initiative.find(params[:id])
  end

  def set_edit_data
    @groups = current_user.groups.all.map { |group| [group.name, group.id] }

    @initiative_statuses =
      InitiativeStatus.all.map do |initiative_status|
        [initiative_status.name, initiative_status.id]
      end

    @taxonomy_hierarchy_json = Solution.hierarchy.to_json
  end

  def check_user_belongs_to_group
    unless current_user.groups.include?(@initiative.lead_group)
      @initiative.errors.add(:base, 'Invalid group')
      return false
    end
    true
  end

  # rubocop:disable Metrics/MethodLength
  def initiative_params
    params.require(:initiative).permit(
      :name,
      :summary,
      :anticipated_carbon_saving,
      :locality,
      :location,
      :latitude,
      :longitude,
      :alternative_solution_name,
      :lead_group_id,
      :contact_name,
      :contact_email,
      :contact_phone,
      :partner_groups_role,
      :status_id,
      :consent_to_share,
      solutions_attributes: %i[solution_id solution_class_id],
      images: [],
      websites_attributes: %i[website id _destroy]
    )
  end
  # rubocop:enable Metrics/MethodLength
end
