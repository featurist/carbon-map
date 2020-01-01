# frozen_string_literal: true

require 'test_helper'

class DistrictsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in_as :georgie
    get districts_url
    assert_response :success

    assert_select '[data-content=District]', text: 'Stroud'
  end
end
