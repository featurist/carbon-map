# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class InitiativesController < ApplicationController
  before_action :set_initiative, only: %i[edit update]
  before_action :set_edit_data, only: %i[edit new create update]
  skip_before_action :authenticate_user!, only: %i[index show]
  helper_method :can_edit?

  def can_edit?(initiative)
    initiative.owner == current_user || current_user&.role == 'admin'
  end

  def index
    current_users_initiatives = current_user&.initiatives || []
    @initiatives = if current_user&.role == 'admin'
                     Initiative.all.sort_by(&:name)
                   else
                     (Initiative.published + current_users_initiatives).uniq.sort_by(&:name)
                   end
  end

  def show
    @initiative = Initiative.find(params['id'])
    @page_description = @initiative.description_what
    @parish = @initiative.parish
    @ward = @parish.ward
    @district = @ward.district
    @map_data = MapData.new([@initiative])
    render layout: false, template: 'initiatives/map_view' if request.xhr?
  end

  def new
    @initiative = Initiative.new
    @initiative.lead_group = Group.new
    @initiative.lead_group.websites << GroupWebsite.new
    @initiative.websites << InitiativeWebsite.new
  end

  def edit; end

  # rubocop:disable Metrics/MethodLength
  def create
    create_proposed_solutions
    @initiative = Initiative.new(initiative_params.merge(owner: current_user))
    find_or_create_group
    @initiative.update_location_from_postcode

    if @initiative.save(validate: @initiative.publication_status != 'draft')
      redirect_to edit_initiative_path(@initiative),
                  notice: 'Initiative was successfully created.'
    else
      render :new
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
  def update
    publication_status = @initiative.publication_status
    if publication_status == 'archived'
      redirect_to initiatives_path, notice: "'#{@initiative.name}' has been archived and cannot be edited"
      return
    end

    initiative_params.delete(:publication_status) if publication_status == 'rejected' && current_user.role != 'admin'

    clear_solutions_and_themes && create_proposed_solutions
    images = initiative_params.delete 'images'
    find_or_create_group
    @initiative.assign_attributes initiative_params
    @initiative.update_location_from_postcode

    if @initiative.save(validate: publication_status != 'draft')
      @initiative.images.attach images if images
      redirect_to edit_initiative_path(@initiative),
                  notice: 'Initiative was successfully updated.'
    else
      render :edit
    end
  end
  # rubocop:enable Metrics/MethodLength, Metrics/AbcSize, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity

  private

  def set_group_types
    @group_types = GroupType.all.order(name: :asc).map do |group|
      [group.name, group.id]
    end
  end

  def clear_solutions_and_themes
    @initiative.themes.clear
    @initiative.solutions.clear
  end

  def set_initiative
    @initiative = Initiative.find(params[:id])

    redirect_to initiatives_url unless can_edit?(@initiative)
  end

  def set_edit_data
    set_group_types
    @groups = Group.all.order(name: :asc).map { |group| [group.name, group.id] }

    @initiative_statuses =
      InitiativeStatus.all.map do |initiative_status|
        [initiative_status.name, initiative_status.id]
      end

    @taxonomy_hierarchy_json = Solution.hierarchy.to_json
  end

  def new_group
    @initiative.lead_group =
      current_user.groups.new(initiative_params[:lead_group_attributes])
    true
  end

  def select_group
    lead_group_id = initiative_params[:lead_group_id]
    @initiative.lead_group = Group.find(lead_group_id) if lead_group_id.present?
  end

  def find_or_create_group
    return new_group if initiative_params[:lead_group_id] == 'new'

    initiative_params.delete('lead_group_attributes')
    select_group
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
        :description_what,
        :description_how,
        :description_further_information,
        :carbon_saving_anticipated,
        :carbon_saving_quantified,
        :carbon_saving_amount,
        :postcode,
        :latitude,
        :longitude,
        :lead_group_id,
        :contact_name,
        :contact_email,
        :contact_phone,
        :partner_groups_role,
        :status_id,
        :publication_status,
        :consent_to_share,
        :related_initiatives,
        :administrative_notes,
        themes_attributes: %i[theme_id],
        solutions_attributes: %i[
          solution_id
          solution_class_id
          proposed_solution
        ],
        images: [],
        websites_attributes: %i[url id _destroy],
        lead_group_attributes: %i[
          name
          abbreviation
          opening_hours
          contact_name
          contact_email
          contact_phone
          consent_to_share
          websites_attributes
        ]
      )
  end
  # rubocop:enable Metrics/MethodLength
end
# rubocop:enable Metrics/ClassLength
