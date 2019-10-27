# frozen_string_literal: true

require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_path
    assert_response :success
  end

  test 'authenticated consumer should only see consumer menu' do
    sign_in_as :georgie

    get root_path
    assert_select 'a', text: 'Initiatives'
    assert_select 'a', text: 'Groups'
    assert_select 'a', text: 'Group Types', count: 0
    assert_select 'a', text: 'Initiative Statuses', count: 0
  end

  test 'authenticated admin should see admin menu' do
    sign_in_as :al_pacino

    get root_path
    assert_select 'a', text: 'Initiatives'
    assert_select 'a', text: 'Groups'
    assert_select 'a', text: 'Group Types'
    assert_select 'a', text: 'Initiative Statuses'
  end
end
