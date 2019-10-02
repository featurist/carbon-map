# frozen_string_literal: true

class GroupTypesController < ApplicationController
  before_action :set_group_type, only: %i[show edit update destroy]

  def index
    @group_types = GroupType.all
  end

  def show; end

  def new
    @group_type = GroupType.new
  end

  def edit; end

  def create
    @group_type = GroupType.new(group_type_params)

    if @group_type.save
      redirect_to @group_type, notice: 'Group type was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group_type.update(group_type_params)
      redirect_to @group_type, notice: 'Group type was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group_type.destroy!
    redirect_to group_types_url, notice: 'Group type was successfully destroyed.'
  end

  private

  def set_group_type
    @group_type = GroupType.find(params[:id])
  end

  def group_type_params
    params.require(:group_type).permit(:name)
  end
end
