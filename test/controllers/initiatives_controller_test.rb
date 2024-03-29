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

  test 'should get index when anonymous' do
    get initiatives_url
    assert_select '.Initiative', count: Initiative.all.size
    assert_select '*[data-content=edit-initiative]', count: 0
    assert_response :success
  end

  test 'should get index when signed in' do
    georgie = users(:georgie)
    sign_in_as :georgie
    get initiatives_url
    assert_select '.Initiative', count: Initiative.all.size
    assert_select '*[data-content=edit-initiative]', count: georgie.initiatives.size
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
      VCR.use_cassette('valid_postcode') do
        post initiatives_url, params: create_params(@initiative, images: images)
      end
    end
    initiative = Initiative.last
    websites = initiative.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].url
    assert_equal 'http://two', websites[1].url
    assert_equal 1, initiative.images.size
    assert_equal 'initial notes', initiative.administrative_notes

    assert_redirected_to edit_initiative_step_path(Initiative.last, step: 2)
  end

  test 'create draft initiative' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      post initiatives_url, params: { initiative: { name: 'draft init', publication_status: 'draft' } }
    end
    initiative = Initiative.last
    assert_equal 'draft init', initiative.name

    assert_redirected_to edit_initiative_step_path(Initiative.last, step: 2)
  end

  test 'archived initiative cannot be edited' do
    @initiative.update!(publication_status: 'archived')

    sign_in_as :georgie
    patch initiative_url(@initiative),
          params: update_params(@initiative)

    assert_redirected_to initiatives_path
  end

  test 'pubication status ignored on rejected initiative' do
    @initiative.update!(publication_status: 'rejected')

    sign_in_as :georgie
    VCR.use_cassette('valid_postcode') do
      patch initiative_url(@initiative),
            params: update_params(@initiative, publication_status: 'published')
    end

    assert_equal 'rejected', @initiative.reload.publication_status
  end

  test 'cannot publish initiative in an invalid state' do
    @initiative.update!(publication_status: 'draft')
    @initiative.name = ''

    sign_in_as :georgie
    VCR.use_cassette('valid_postcode') do
      patch initiative_url(@initiative),
            params: update_params(@initiative, publication_status: 'published')
    end

    assert_equal 'draft', @initiative.reload.publication_status
  end

  test 'create initiative and lead group' do
    sign_in_as :georgie
    lead_group = {
      name: 'my group',
      abbreviation: 'mg',
      contact_name: 'group contact',
      contact_email: 'test@test.com',
      contact_phone: '123'
    }

    assert_difference('Initiative.count') do
      assert_difference('Group.count') do
        VCR.use_cassette('valid_postcode') do
          post initiatives_url,
               params: create_params(@initiative, lead_group: lead_group)
        end
      end
    end

    assert_redirected_to edit_initiative_step_path(Initiative.last, step: 2)
    assert_equal 'group contact', Group.last.contact_name
    assert_equal 'my group', Group.last.name
  end

  test 'create initiative with no anticipated carbon saving' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      VCR.use_cassette('valid_postcode') do
        post initiatives_url, params: create_params(@initiative,
                                                    carbon_saving_anticipated: false,
                                                    carbon_saving_amount: nil)
      end
    end
    initiative = Initiative.last
    assert_not initiative.carbon_saving_anticipated?
    assert_not initiative.carbon_saving_quantified?
    assert_nil initiative.carbon_saving_amount
  end

  test 'create initiative with unquantified carbon saving' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      VCR.use_cassette('valid_postcode') do
        post initiatives_url, params: create_params(@initiative,
                                                    carbon_saving_anticipated: true,
                                                    carbon_saving_amount: nil)
      end
    end
    initiative = Initiative.last
    assert initiative.carbon_saving_anticipated?
    assert_not initiative.carbon_saving_quantified?
    assert_nil initiative.carbon_saving_amount
  end

  test 'create initiative with carbon saving' do
    sign_in_as :georgie
    assert_difference('Initiative.count') do
      VCR.use_cassette('valid_postcode') do
        post initiatives_url, params: create_params(@initiative,
                                                    carbon_saving_anticipated: true,
                                                    carbon_saving_amount: 200)
      end
    end
    initiative = Initiative.last
    assert initiative.carbon_saving_anticipated?
    assert initiative.carbon_saving_quantified?
    assert_equal 200, initiative.carbon_saving_amount
  end

  test 'create initiative with solution' do
    sign_in_as :georgie
    solution_class = SolutionSolutionClass.last.solution_class
    solution = SolutionSolutionClass.last.solution

    assert_difference('Initiative.count') do
      solutions = [
        "#{solution.id},#{solution_class.id}"
      ]
      VCR.use_cassette('valid_postcode') do
        post initiatives_url,
             params: create_params(@initiative, solutions: solutions)
      end
    end

    initiative_solution = Initiative.last.solutions.last
    assert_equal solution, initiative_solution.solution
    assert_equal solution_class, initiative_solution.solution_class
  end

  test 'update initiative with new solutions' do
    sign_in_as :georgie
    solution_solution_class = solution_solution_classes(:two)
    solution_class = solution_solution_class.solution_class
    solution = solution_solution_class.solution
    initiative = initiatives(:fruit_exchange)

    assert_no_difference('Initiative.count') do
      solutions = [
        "#{solution.id},#{solution_class.id}"
      ]
      VCR.use_cassette('valid_postcode') do
        put initiative_url(initiative),
            params: create_params(@initiative, solutions: solutions)
      end
    end

    initiative_solution = initiative.reload.solutions.last
    assert_equal solution, initiative_solution.solution
    assert_equal solution_class, initiative_solution.solution_class
  end

  # test 'create initiative with alternative solution' do
  #   sign_in_as :georgie
  #   assert_difference('Initiative.count') do
  #     solutions = {
  #       '0': {
  #         solution_class_id: SolutionClass.last.id,
  #         proposed_solution: 'An amazing new thing'
  #       }
  #     }
  #     VCR.use_cassette('valid_postcode') do
  #       post initiatives_url,
  #            params: create_params(@initiative, solutions: solutions)
  #     end
  #   end

  #   proposed_solution = Solution.last
  #   assert_equal 'An amazing new thing', proposed_solution.name
  #   assert proposed_solution.proposed?
  #   assert_equal users(:georgie), proposed_solution.created_by
  #   assert_nil proposed_solution.approved_by
  # end

  test 'should get edit' do
    sign_in_as :georgie
    get edit_initiative_url(@initiative)
    assert_response :success
  end

  test 'cannot GET edit for an initiative you do not own' do
    initiative = initiatives(:brians_initiative)
    sign_in_as :georgie
    get edit_initiative_url(initiative)
    assert_redirected_to initiatives_url
  end

  test 'cannot PATCH edit for an initiative you do not own' do
    initiative = initiatives(:brians_initiative)
    sign_in_as :georgie
    patch initiative_url(initiative), params: update_params(initiative)
    assert_redirected_to initiatives_url
  end

  test 'should update initiative' do
    sign_in_as :georgie
    @initiative.images.attach(header_image)
    images = [avenue_image]
    VCR.use_cassette('valid_postcode') do
      patch initiative_url(@initiative),
            params: update_params(@initiative, images: images)
    end
    assert_equal 2, @initiative.reload.images.size
    websites = @initiative.websites
    assert_equal 2, websites.size
    assert_equal 'http://one', websites[0].url
    assert_equal 'http://two', websites[1].url
    assert_equal 'updated notes', @initiative.administrative_notes
    assert_redirected_to initiative_path(@initiative)
  end

  test 'update without themese and solutions retains previous values' do
    sign_in_as :georgie
    expected_themes = @initiative.themes.map(&:id)
    expected_solutions = @initiative.solutions.map(&:id)
    params = update_params(@initiative)
    params[:initiative][:solutions] = nil
    params[:initiative][:themes] = nil

    VCR.use_cassette('valid_postcode') do
      patch initiative_url(@initiative), params: params
    end

    @initiative.reload

    assert_equal expected_themes, @initiative.themes.map(&:id)
    assert_equal expected_solutions, @initiative.solutions.map(&:id)
  end

  private

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/ParameterLists
  def create_params(initiative, lead_group: nil, images: nil, solutions: nil,
                    carbon_saving_anticipated: false, carbon_saving_amount: nil)
    solutions ||= default_solutions
    {
      initiative: {
        carbon_saving_anticipated: carbon_saving_anticipated,
        carbon_saving_amount: carbon_saving_amount,
        contact_email: initiative.contact_email,
        contact_name: initiative.contact_name,
        contact_phone: initiative.contact_phone,
        lead_group_id: lead_group ? 'new' : initiative.lead_group_id,
        lead_group_attributes: lead_group,
        name: initiative.name,
        partner_groups_role: initiative.partner_groups_role,
        status_id: initiative.status_id,
        description_further_information:
          initiative.description_further_information,
        description_what: initiative.description_what,
        description_how: initiative.description_how,
        images: images,
        postcode: 'GL54UB',
        consent_to_share: true,
        solutions: solutions,
        administrative_notes: 'initial notes',
        websites_attributes: [
          { url: 'http://one' },
          { url: 'http://two' }
        ]
      }
    }
  end

  def update_params(initiative, images: nil, solutions: nil,
                    carbon_saving_anticipated: false,
                    carbon_saving_amount: nil, publication_status: nil)
    solutions ||= default_solutions
    {
      initiative: {
        carbon_saving_anticipated: carbon_saving_anticipated,
        carbon_saving_strategy: 'save carbon',
        carbon_saving_amount: carbon_saving_amount,
        contact_email: initiative.contact_email,
        contact_name: initiative.contact_name,
        contact_phone: initiative.contact_phone,
        lead_group_id: initiative.lead_group_id,
        name: initiative.name,
        partner_groups_role: initiative.partner_groups_role,
        status_id: initiative.status_id,
        description_further_information:
          initiative.description_further_information,
        description_what: initiative.description_what,
        description_how: initiative.description_how,
        images: images,
        consent_to_share: true,
        publication_status: publication_status || initiative.publication_status,
        solutions: solutions,
        administrative_notes: 'updated notes',
        websites_attributes: [
          { url: 'http://one' },
          { url: 'http://two' }
        ]
      }
    }
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/MethodLength

  def default_solutions
    solution_class = SolutionSolutionClass.last.solution_class
    solution = SolutionSolutionClass.last.solution

    ["#{solution.id},#{solution_class.id}"]
  end
end
