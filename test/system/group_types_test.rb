# frozen_string_literal: true

require 'application_system_test_case'

class GroupTypesTest < ApplicationSystemTestCase
  setup { @group_type = group_types(:one) }

  test 'visiting the index' do
    visit group_types_url
    sign_in_as :al_pacino
    assert_selector 'h1', text: 'Group Types'
  end

  test 'creating a Group type' do
    visit group_types_url
    sign_in_as :al_pacino
    click_on 'New Group Type'

    fill_in 'Name', with: @group_type.name
    click_on 'Create Group type'

    assert_text 'Group type was successfully created'
  end

  test 'updating a Group type' do
    visit group_types_url
    sign_in_as :al_pacino
    click_on 'Edit', match: :first

    fill_in 'Name', with: @group_type.name
    click_on 'Update Group type'

    assert_text 'Group type was successfully updated'
  end
end
