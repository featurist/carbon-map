# frozen_string_literal: true

class GroupWebsitesController < ApplicationController
  before_action :set_group_website, only: %i[show edit update destroy]

  before_action :set_group

  def index
    @group_websites = @group.websites
  end

  def show; end

  def new
    @group_website = @group.websites.new
  end

  def edit; end

  def create
    @group_website = @group.websites.new(group_website_params)

    if @group_website.save
      redirect_to group_group_websites_url(@group), notice: 'Group website was successfully created.'
    else
      render :new
    end
  end

  def update
    if @group_website.update(group_website_params)
      redirect_to [@group, @group_website], notice: 'Group website was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @group_website.destroy
    redirect_to group_group_websites_url(@group), notice: 'Group website was successfully destroyed.'
  end

  private

  def set_group
    @group = current_user.groups.find(params['group_id'])
  end

  def set_group_website
    @group_website = GroupWebsite.find(params[:id])
  end

  def group_website_params
    params.require(:group_website).permit(:website, :group_id)
  end
end
