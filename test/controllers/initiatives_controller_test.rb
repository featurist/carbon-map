# frozen_string_literal: true

require 'test_helper'

class InitiativesControllerTest < ActionDispatch::IntegrationTest
  setup { @initiative = initiatives(:fruit_exchange) }

  def avenue_image
    Rack::Test::UploadedFile.new('test/fixtures/files/avenue.jpg', 'image/jpeg')
  end

  def header_image
    Rack::Test::UploadedFile.new('test/fixtures/files/header.jpg', 'image/jpeg')
  end

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
      images = [header_image]
      post initiatives_url,
           params: {
             initiative: {
               alternative_solution_name: @initiative.alternative_solution_name,
               anticipated_carbon_saving: @initiative.anticipated_carbon_saving,
               contact_email: @initiative.contact_email,
               contact_name: @initiative.contact_name,
               contact_phone: @initiative.contact_phone,
               lead_group_id: @initiative.lead_group_id,
               locality: @initiative.locality,
               location: @initiative.location,
               name: @initiative.name,
               partner_groups_role: @initiative.partner_groups_role,
               status_id: @initiative.status_id,
               summary: @initiative.summary,
               images: images,
               consent_to_share: true,
               websites_attributes: [
                 { website: 'http://one' },
                 { website: 'http://two' }
               ]
             }
           }
      assert_equal 1, Initiative.last.images.size
    end
    websites = Initiative.last.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website

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
    @initiative.images.attach(header_image)
    images = [avenue_image]
    patch initiative_url(@initiative),
          params: {
            initiative: {
              alternative_solution_name: @initiative.alternative_solution_name,
              anticipated_carbon_saving: @initiative.anticipated_carbon_saving,
              contact_email: @initiative.contact_email,
              contact_name: @initiative.contact_name,
              contact_phone: @initiative.contact_phone,
              lead_group_id: @initiative.lead_group_id,
              locality: @initiative.locality,
              location: @initiative.location,
              name: @initiative.name,
              partner_groups_role: @initiative.partner_groups_role,
              status_id: @initiative.status_id,
              summary: @initiative.summary,
              images: images,
              consent_to_share: true,
              websites_attributes: [
                { website: 'http://one' },
                { website: 'http://two' }
              ]
            }
          }
    assert_equal 2, @initiative.reload.images.size
    websites = @initiative.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website
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
