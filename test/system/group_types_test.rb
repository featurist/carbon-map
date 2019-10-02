# frozen_string_literal: true

require 'application_system_test_case'

class GroupTypesTest < ApplicationSystemTestCase
  setup do
    @group_type = group_types(:one)
  end

  test 'visiting the index' do
    visit group_types_url
    assert_selector 'h1', text: 'Group Types'
  end

  test 'creating a Group type' do
    visit group_types_url
    click_on 'New Group Type'

    fill_in 'Name', with: @group_type.name
    click_on 'Create Group type'

    assert_text 'Group type was successfully created'
    click_on 'Back'
  end

  test 'updating a Group type' do
    visit group_types_url
    click_on 'Edit', match: :first

    fill_in 'Name', with: @group_type.name
    click_on 'Update Group type'

    assert_text 'Group type was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Group type' do
    visit group_types_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Group type was successfully destroyed'
  end
end
