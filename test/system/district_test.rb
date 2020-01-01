# frozen_string_literal: true

require 'application_system_test_case'

class DistrictTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit districts_url
    click_link 'Stroud'

    assert_heading 'Stroud'
  end
end
