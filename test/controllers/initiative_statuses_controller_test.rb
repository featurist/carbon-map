# frozen_string_literal: true

require 'test_helper'

class InitiativeStatusesControllerTest < ActionDispatch::IntegrationTest
  setup { @initiative_status = initiative_statuses(:one) }

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
               description: @initiative_status.description,
               name: @initiative_status.name
             }
           }
    end

    assert_redirected_to initiative_statuses_path
  end

  test 'should show initiative_status' do
    sign_in_as :georgie
    get initiative_status_url(@initiative_status)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_initiative_status_url(@initiative_status)
    assert_response :success
  end

  test 'should update initiative_status' do
    sign_in_as :georgie
    patch initiative_status_url(@initiative_status),
          params: {
            initiative_status: {
              description: @initiative_status.description,
              name: @initiative_status.name
            }
          }
    assert_redirected_to initiative_status_url(@initiative_status)
  end

  test 'should destroy initiative_status' do
    sign_in_as :georgie
    initiative_status = initiative_statuses(:unused)
    assert_difference('InitiativeStatus.count', -1) do
      delete initiative_status_url(initiative_status)
    end

    assert_redirected_to initiative_statuses_url
  end
end
