# frozen_string_literal: true

require 'test_helper'

class InitiativesControllerTest < ActionDispatch::IntegrationTest
  setup { @initiative = initiatives(:fruit_exchange) }

  test 'should get index' do
    sign_in_as :georgie
    get initiatives_url
    assert_response :success
  end

  test 'should get new' do
    sign_in_as :georgie
    get new_initiative_url
    assert_response :success
  end

  test 'should create initiative' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      post initiatives_url,
           params: {
             initiative: {
               alternative_solution_name: @initiative.alternative_solution_name,
               anticipated_carbon_saving: @initiative.anticipated_carbon_saving,
               contact_email: @initiative.contact_email,
               contact_name: @initiative.contact_name,
               contact_phone: @initiative.contact_phone,
               gdpr: @initiative.gdpr,
               gdpr_email_verified: @initiative.gdpr_email_verified,
               image_url: @initiative.image_url,
               lead_group_id: @initiative.lead_group_id,
               locality: @initiative.locality,
               location: @initiative.location,
               name: @initiative.name,
               partner_groups_role: @initiative.partner_groups_role,
               status_id: @initiative.status_id,
               summary: @initiative.summary
             }
           }
    end

    assert_redirected_to initiatives_path
  end

  test 'should show initiative' do
    sign_in_as :georgie
    get initiative_url(@initiative)
    assert_response :success
  end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_initiative_url(@initiative)
    assert_response :success
  end

  test 'should update initiative' do
    sign_in_as :georgie
    patch initiative_url(@initiative),
          params: {
            initiative: {
              alternative_solution_name: @initiative.alternative_solution_name,
              anticipated_carbon_saving: @initiative.anticipated_carbon_saving,
              contact_email: @initiative.contact_email,
              contact_name: @initiative.contact_name,
              contact_phone: @initiative.contact_phone,
              gdpr: @initiative.gdpr,
              gdpr_email_verified: @initiative.gdpr_email_verified,
              image_url: @initiative.image_url,
              lead_group_id: @initiative.lead_group_id,
              locality: @initiative.locality,
              location: @initiative.location,
              name: @initiative.name,
              partner_groups_role: @initiative.partner_groups_role,
              status_id: @initiative.status_id,
              summary: @initiative.summary
            }
          }
    assert_redirected_to initiative_url(@initiative)
  end

  test 'should destroy initiative' do
    sign_in_as :georgie
    assert_difference('Initiative.count', -1) do
      delete initiative_url(@initiative)
    end

    assert_redirected_to initiatives_url
  end
end
