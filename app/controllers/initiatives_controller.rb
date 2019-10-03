class InitiativesController < ApplicationController
  before_action :set_initiative, only: [:show, :edit, :update, :destroy]
  before_action :set_edit_data, only: [:edit, :new]

  def index
    @initiatives = Initiative.all
  end

  def show
  end

  def new
    @initiative = Initiative.new
  end

  def edit
  end

  def create
    @initiative = Initiative.new(initiative_params)

    if @initiative.save
      redirect_to initiatives_path, notice: 'Initiative was successfully created.'
    else
      render :new
    end
  end

  def update
    if @initiative.update(initiative_params)
      redirect_to @initiative, notice: 'Initiative was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /initiatives/1
  # DELETE /initiatives/1.json
  def destroy
    @initiative.destroy
    redirect_to initiatives_url, notice: 'Initiative was successfully destroyed.'
  end

  private

  def set_initiative
    @initiative = Initiative.find(params[:id])
  end

  def set_edit_data
    @groups = Group.all.map do |group|
      [group.name, group.id]
    end

    @initiative_statuses = InitiativeStatus.all.map do |initiative_status|
      [initiative_status.name, initiative_status.id]
    end
  end

  def initiative_params
    params.require(:initiative).permit(:name,
                                       :summary,
                                       :image_url,
                                       :anticipated_carbon_saving,
                                       :locality,
                                       :location,
                                       :alternative_solution_name,
                                       :lead_group_id,
                                       :contact_name,
                                       :contact_email,
                                       :contact_phone,
                                       :partner_groups_role,
                                       :status_id,
                                       :gdpr,
                                       :gdpr_email_verified
                                      )
  end
end
