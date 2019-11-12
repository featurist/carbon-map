# frozen_string_literal: true

class GroupTypesController < ApplicationController
  before_action :set_group_type, only: %i[edit update]

  def index
    @group_types = GroupType.all
  end

  def new
    @group_type = GroupType.new
  end

  def edit; end

  def create
    @group_type = GroupType.new(group_type_params)

    if @group_type.save
      redirect_to [:edit, @group_type],
                  notice: 'Group type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group_type.update(group_type_params)
      redirect_to [:edit, @group_type],
                  notice: 'Group type was successfully updated.'
    else
      render :edit
    end
  end

  def set_group_type
    @group_type = GroupType.find(params[:id])
  end

  def group_type_params
    params.require(:group_type).permit(:name)
  end
end
