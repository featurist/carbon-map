# frozen_string_literal: true

class InitiativeStatusesController < ApplicationController
  before_action :set_initiative_status, only: %i[edit update]

  def index
    @initiative_statuses = InitiativeStatus.all
  end

  def new
    @initiative_status = InitiativeStatus.new
  end

  def edit; end

  def create
    @initiative_status = InitiativeStatus.new(initiative_status_params)

    if @initiative_status.save
      redirect_to [:edit, @initiative_status],
                  notice: 'Initiative status was successfully created.'
    else
      render :new
    end
  end

  def update
    if @initiative_status.update(initiative_status_params)
      redirect_to [:edit, @initiative_status],
                  notice: 'Initiative status was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_initiative_status
    @initiative_status = InitiativeStatus.find(params[:id])
  end

  def initiative_status_params
    params.require(:initiative_status).permit(:name, :description)
  end
end
