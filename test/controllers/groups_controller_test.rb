# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group = groups(:one)
  end

  test 'should get index' do
    sign_in_as :georgie
    get groups_url
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_group_url
    assert_response :success
  end

  test 'should create group' do
    sign_in_as :georgie
    assert_difference('Group.count') do
      post groups_url, params: {
        group: {
          abbreviation: @group.abbreviation,
          contact_email: @group.contact_email,
          contact_name: @group.contact_name,
          contact_phone: @group.contact_phone,
          gdpr: @group.gdpr,
          gdpr_email_verified: @group.gdpr_email_verified,
          name: @group.name,
          opening_hours: @group.opening_hours
        }
      }
    end

    assert_redirected_to group_url(Group.last)
  end

  test 'should show group' do
    sign_in_as :georgie
    get group_url(@group)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_group_url(@group)
    assert_response :success
  end

  test 'should update group' do
    sign_in_as :georgie
    patch group_url(@group), params: {
      group: {
        abbreviation: @group.abbreviation,
        contact_email: @group.contact_email,
        contact_name: @group.contact_name,
        contact_phone: @group.contact_phone,
        gdpr: @group.gdpr,
        gdpr_email_verified: @group.gdpr_email_verified,
        name: @group.name,
        opening_hours: @group.opening_hours
      }
    }
    assert_redirected_to group_url(@group)
  end

  test 'should destroy group' do
    sign_in_as :georgie
    group = groups(:unused)
    assert_difference('Group.count', -1) do
      delete group_url(group)
    end

    assert_redirected_to groups_url
  end
end
