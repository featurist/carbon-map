# frozen_string_literal: true

class GroupsController < ApplicationController
  before_action :set_group, only: %i[edit update]
  before_action :set_group_types, only: %i[new edit create update]

  def index
    @groups = current_user.groups.all
  end

  def new
    @group = current_user.groups.new
    @group.websites << GroupWebsite.new
  end

  def edit; end

  def create
    @group = current_user.groups.new
    attach_types(@group, group_params)
    @group.assign_attributes(group_params)

    if @group.save
      redirect_to edit_group_path(@group),
                  notice: 'Group was successfully created.'
    else
      render :new
    end
  end

  def update
    attach_types(@group, group_params)
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

  def set_group_types
    @group_types = GroupType.all.order(name: :asc).map do |group|
      [group.name, group.id]
    end
  end

  def attach_types(group, group_params)
    types = group_params.delete(:types).reject(&:empty?)
    group.types.clear

    types.each do |group_type_id|
      group.types << GroupGroupType.new(group_type: GroupType.find(group_type_id))
    end
  end

  # rubocop:disable Metrics/MethodLength
  def group_params
    @group_params ||= params.require(:group).permit(
      :name,
      :abbreviation,
      :opening_hours,
      :contact_name,
      :contact_email,
      :contact_phone,
      :consent_to_share,
      types: [],
      websites_attributes: %i[url id _destroy]
    )
  end
  # rubocop:enable Metrics/MethodLength
end
