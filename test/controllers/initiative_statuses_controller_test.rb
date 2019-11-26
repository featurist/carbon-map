# frozen_string_literal: true

require 'test_helper'

class InitiativeStatusesControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in_as :georgie
    get initiative_statuses_url
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_initiative_status_url
    assert_response :success
  end

  test 'should create initiative_status' do
    sign_in_as :georgie
    assert_difference('InitiativeStatus.count') do
      post initiative_statuses_url,
           params: {
             initiative_status: {
               description: 'status description', name: 'status name'
             }
           }
    end

    assert_redirected_to edit_initiative_status_path(InitiativeStatus.last)
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_initiative_status_url(initiative_statuses(:unused))
    assert_response :success
  end

  test 'should update initiative_status' do
    initiative = initiative_statuses(:unused)
    sign_in_as :georgie
    patch initiative_status_url(initiative),
          params: {
            initiative_status: {
              description: 'status description', name: 'status name'
            }
          }
    assert_redirected_to edit_initiative_status_url(initiative)
  end
end
