# frozen_string_literal: true

require 'application_system_test_case'

class GroupsTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit groups_url
    sign_in_as :georgie
    assert_selector 'h1', text: 'Groups'
  end

  test 'creating a Group' do
    visit groups_url
    sign_in_as :georgie
    click_on 'New Group'

    fill_in 'Abbreviation', with: 'abb'
    fill_in 'Name', with: 'test name'
    fill_in 'Contact email', with: 'test@test.com'
    fill_in 'Contact name', with: 'test contact'
    fill_in 'Contact phone', with: 'test phone'
    click_on 'Create Group'

    assert_text 'Group was successfully created'
  end

  test 'updating a Group' do
    visit groups_url
    sign_in_as :georgie
    click_on 'Edit', match: :first

    fill_in 'Abbreviation', with: 'abb'
    fill_in 'Name', with: 'test name'
    fill_in 'Contact email', with: 'test@test.com'
    fill_in 'Contact name', with: 'test contact'
    fill_in 'Contact phone', with: 'test phone'
    click_on 'Update Group'

    assert_text 'Group was successfully updated'
  end
end
