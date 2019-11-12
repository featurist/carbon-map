# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class InitiativesController < ApplicationController
  before_action :set_initiative, only: %i[edit update]
  before_action :set_edit_data, only: %i[edit new create update]

  def index
    @initiatives = current_user.initiatives.all
  end

  def new
    @initiative = Initiative.new
  end

  def edit; end

  def create
    create_proposed_solutions
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
    create_proposed_solutions
    images = initiative_params.delete 'images'

    if check_user_belongs_to_group && @initiative.update(initiative_params)
      @initiative.images.attach images if images
      redirect_to edit_initiative_path(@initiative),
                  notice: 'Initiative was successfully updated.'
    else
      render :edit
    end
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
  # rubocop:disable Metrics/AbcSize
  def create_proposed_solutions
    return unless initiative_params['solutions_attributes']

    initiative_params['solutions_attributes'] =
      initiative_params['solutions_attributes'].values
    proposed_solutions =
      initiative_params['solutions_attributes'].filter do |solution|
        solution['proposed_solution'].present?
      end
    initiative_params['solutions_attributes'].reject! do |solution|
      solution['proposed_solution'].present?
    end
    proposed_solutions.each do |proposed_solution|
      solution_solution_class = create_proposed_solution(proposed_solution)
      append_solution(
        solution_solution_class.solution,
        solution_solution_class.solution_class
      )
    end
  end
  # rubocop:enable Metrics/AbcSize

  def append_solution(solution, solution_class)
    initiative_params['solutions_attributes'] <<
      { 'solution_id': solution.id, 'solution_class_id': solution_class.id }
  end

  def create_proposed_solution(proposed_solution)
    solution_class = SolutionClass.find(proposed_solution['solution_class_id'])
    solution =
      Solution.new(
        name: proposed_solution['proposed_solution'], created_by: current_user
      )
    solution_solution_class =
      SolutionSolutionClass.new(
        solution: solution, solution_class: solution_class
      )
    solution.solution_solution_classes << solution_solution_class
    solution.save!

    solution_solution_class
  end

  def initiative_params
    @initiative_params ||=
      params.require(:initiative).permit(
        :name,
        :summary,
        :anticipated_carbon_saving,
        :locality,
        :location,
        :latitude,
        :longitude,
        :lead_group_id,
        :contact_name,
        :contact_email,
        :contact_phone,
        :partner_groups_role,
        :status_id,
        :consent_to_share,
        solutions_attributes: %i[
          solution_id
          solution_class_id
          proposed_solution
        ],
        images: [],
        websites_attributes: %i[website id _destroy]
      )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
