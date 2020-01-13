# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
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
      post groups_url,
           params: {
             group: {
               abbreviation: 'abb',
               name: 'test group',
               contact_email: 'contact@test.com',
               contact_name: 'test contact',
               contact_phone: 'test phone',
               consent_to_share: true,
               types: %w[2 4],
               websites_attributes: [
                 { url: 'http://one' },
                 { url: 'http://two' }
               ]
             }
           }
    end

    group = Group.last
    websites = group.websites.sort_by(&:url)
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].url
    assert_equal 'http://two', websites[1].url
    assert_equal GroupType.find(2), group.types[0].group_type
    assert_equal GroupType.find(4), group.types[1].group_type

    assert_redirected_to edit_group_path(Group.last)
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_group_url(groups(:down_to_earth_stroud))
    assert_response :success
  end

  test 'should update group' do
    sign_in_as :georgie
    group = groups(:down_to_earth_stroud)
    group.websites.delete_all
    group.websites.create! url: 'http://one'

    patch group_url(group),
          params: {
            group: {
              abbreviation: 'app update',
              name: 'update group name',
              contact_email: 'update contact',
              contact_name: 'update name',
              contact_phone: 'update phone',
              types: %w[2 4],
              websites_attributes: [
                { url: 'http://one', id: group.websites[0].id },
                { url: 'http://two' }
              ]
            }
          }
    websites = group.reload.websites.sort_by(&:url)
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].url
    assert_equal 'http://two', websites[1].url
    assert_equal GroupType.find(2), group.types[0].group_type
    assert_equal GroupType.find(4), group.types[1].group_type
    assert_redirected_to edit_group_path(group)
  end
end
