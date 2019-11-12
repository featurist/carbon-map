# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update]

  def index
    @groups = current_user.groups.all
  end

  def new
    @group = current_user.groups.new
  end

  def edit; end

  def create
    @group = current_user.groups.new(group_params)

    if @group.save
      redirect_to edit_group_path(@group),
                  notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group.update(group_params)
      redirect_to edit_group_path(@group),
                  notice: 'Group was successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(
      :name,
      :abbreviation,
      :opening_hours,
      :contact_name,
      :contact_email,
      :contact_phone,
      :consent_to_share,
      websites_attributes: %i[website id _destroy]
    )
  end
end
