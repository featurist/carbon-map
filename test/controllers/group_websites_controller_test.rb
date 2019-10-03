# frozen_string_literal: true

require 'test_helper'

class GroupWebsitesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
    @group_website = group_websites(:one)
  end

  test 'should get index' do
    sign_in_as :georgie
    get group_group_websites_url(@group)
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_group_group_website_url @group
    assert_response :success
  end

  test 'should create group_website' do
    sign_in_as :georgie
    assert_difference('@group.websites.count') do
      post group_group_websites_url(@group), params: {
        group_website: { website: 'http://new.website' }
      }
    end

    assert_redirected_to group_group_websites_path(@group)
  end

  test 'should show group_website' do
    sign_in_as :georgie
    get group_group_website_url(@group, @group_website)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_group_group_website_url(@group, @group_website)
    assert_response :success
  end

  test 'should update group_website' do
    sign_in_as :georgie
    patch group_group_website_url(@group, @group_website), params: {
      group_website: { group: @group_website.group, website: @group_website.website }
    }
    assert_redirected_to group_group_website_url(@group, @group_website)
  end

  test 'should destroy group_website' do
    sign_in_as :georgie
    assert_difference('GroupWebsite.count', -1) do
      delete group_group_website_url(@group, @group_website)
    end

    assert_redirected_to group_group_websites_url @group
  end
end
