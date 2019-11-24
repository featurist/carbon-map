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
      post initiatives_url, params: create_params(@initiative, images: images)
      assert_equal 1, Initiative.last.images.size
    end
    websites = Initiative.last.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website

    assert_redirected_to edit_initiative_path(Initiative.last)
  end

  test 'create initiative and lead group' do
    sign_in_as :georgie
    lead_group = {
      contact_name: 'group contact', name: 'my group', consent_to_share: true
    }

    assert_difference('Initiative.count') do
      assert_difference('Group.count') do
        post initiatives_url,
             params: create_params(@initiative, lead_group: lead_group)
      end
    end

    assert_redirected_to edit_initiative_path(Initiative.last)
    assert_equal 'group contact', Group.last.contact_name
    assert_equal 'my group', Group.last.name
  end

  test 'create initiative with solution' do
    sign_in_as :georgie
    solution_class = SolutionSolutionClass.last.solution_class
    solution = SolutionSolutionClass.last.solution

    assert_difference('Initiative.count') do
      solutions = {
        '0': { solution_class_id: solution_class.id, solution_id: solution.id }
      }
      post initiatives_url,
           params: create_params(@initiative, solutions: solutions)
    end

    initiative_solution = Initiative.last.solutions.last
    assert_equal solution, initiative_solution.solution
    assert_equal solution_class, initiative_solution.solution_class
  end

  test 'create initiative with alternative solution' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      solutions = {
        '0': {
          solution_class_id: SolutionClass.last.id,
          proposed_solution: 'An amazing new thing'
        }
      }
      post initiatives_url,
           params: create_params(@initiative, solutions: solutions)
    end

    proposed_solution = Solution.last
    assert_equal 'An amazing new thing', proposed_solution.name
    assert proposed_solution.proposed?
    assert_equal users(:georgie), proposed_solution.created_by
    assert_nil proposed_solution.approved_by
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
          params: update_params(@initiative, images)
    assert_equal 2, @initiative.reload.images.size
    websites = @initiative.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].website
    assert_equal 'http://two', websites[1].website
    assert_redirected_to edit_initiative_path(@initiative)
  end

  private

  # rubocop:disable Metrics/MethodLength
  def create_params(initiative, lead_group: nil, images: nil, solutions: nil)
    {
      initiative: {
        anticipated_carbon_saving: initiative.anticipated_carbon_saving,
        contact_email: initiative.contact_email,
        contact_name: initiative.contact_name,
        contact_phone: initiative.contact_phone,
        lead_group_id: lead_group ? nil : initiative.lead_group_id,
        lead_group_attributes: lead_group,
        locality: initiative.locality,
        location: initiative.location,
        name: initiative.name,
        partner_groups_role: initiative.partner_groups_role,
        status_id: initiative.status_id,
        summary: initiative.summary,
        images: images,
        consent_to_share: true,
        solutions_attributes: solutions,
        websites_attributes: [
          { website: 'http://one' },
          { website: 'http://two' }
        ]
      }
    }
  end

  def update_params(initiative, images)
    {
      initiative: {
        anticipated_carbon_saving: initiative.anticipated_carbon_saving,
        contact_email: initiative.contact_email,
        contact_name: initiative.contact_name,
        contact_phone: initiative.contact_phone,
        lead_group_id: initiative.lead_group_id,
        locality: initiative.locality,
        location: initiative.location,
        name: initiative.name,
        partner_groups_role: initiative.partner_groups_role,
        status_id: initiative.status_id,
        summary: initiative.summary,
        images: images,
        consent_to_share: true,
        websites_attributes: [
          { website: 'http://one' },
          { website: 'http://two' }
        ]
      }
    }
  end
  # rubocop:enable Metrics/MethodLength
end
