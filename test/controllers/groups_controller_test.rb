# frozen_string_literal: true

require 'test_helper'

class GroupsControllerTest < ActionDispatch::IntegrationTest
  setup { @group = groups(:one) }

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
               abbreviation: @group.abbreviation,
               contact_email: @group.contact_email,
               contact_name: @group.contact_name,
               contact_phone: @group.contact_phone,
               name: @group.name,
               opening_hours: @group.opening_hours,
               consent_to_share: true,
               websites_attributes: [
                 { website: 'http://one' },
                 { website: 'http://two' }
               ]
             }
           }
    end

    websites = Group.last.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website

    assert_redirected_to edit_group_path(Group.last)
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
    @group.websites.delete_all
    @group.websites.create! website: 'http://one'
    patch group_url(@group),
          params: {
            group: {
              abbreviation: @group.abbreviation,
              contact_email: @group.contact_email,
              contact_name: @group.contact_name,
              contact_phone: @group.contact_phone,
              name: @group.name,
              opening_hours: @group.opening_hours,
              websites_attributes: [
                { website: 'http://one', id: @group.websites[0].id },
                { website: 'http://two' }
              ]
            }
          }
    websites = Group.last.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website
    assert_redirected_to edit_group_path(@group)
  end

  test 'should destroy group' do
    sign_in_as :georgie
    group = groups(:unused)
    assert_difference('Group.count', -1) { delete group_url(group) }

    assert_redirected_to groups_url
  end
end
