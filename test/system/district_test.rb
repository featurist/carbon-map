# frozen_string_literal: true

require 'application_system_test_case'

class DistrictTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit districts_url
    click_link 'Stroud'

    assert_text 'Districts > Stroud'
  end
end
