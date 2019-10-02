# frozen_string_literal: true

require 'test_helper'

class GroupTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @group_type = group_types(:one)
  end

  test 'should get index' do
    sign_in_as :georgie
    get group_types_url
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_group_type_url
    assert_response :success
  end

  test 'should create group_type' do
    sign_in_as :georgie
    assert_difference('GroupType.count') do
      post group_types_url, params: { group_type: { name: @group_type.name } }
    end

    assert_redirected_to group_type_url(GroupType.last)
  end

  test 'should show group_type' do
    sign_in_as :georgie
    get group_type_url(@group_type)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_group_type_url(@group_type)
    assert_response :success
  end

  test 'should update group_type' do
    sign_in_as :georgie
    patch group_type_url(@group_type), params: { group_type: { name: @group_type.name } }
    assert_redirected_to group_type_url(@group_type)
  end

  test 'should destroy group_type' do
    sign_in_as :georgie
    assert_difference('GroupType.count', -1) do
      delete group_type_url(@group_type)
    end

    assert_redirected_to group_types_url
  end
end
