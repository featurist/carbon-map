# frozen_string_literal: true

require 'application_system_test_case'

class InitiativeStatusesTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit initiative_statuses_url
    sign_in_as :al_pacino
    assert_selector 'h1', text: 'Initiative Statuses'
  end

  test 'creating a Initiative status' do
    visit initiative_statuses_url
    sign_in_as :al_pacino
    click_on 'New Initiative Status'

    fill_in 'Description', with: 'description of status'
    fill_in 'Name', with: 'name of status'
    click_on 'Create Initiative status'

    assert_text 'Initiative status was successfully created'
  end

  test 'updating a Initiative status' do
    visit initiative_statuses_url
    sign_in_as :al_pacino
    click_on 'Edit', match: :first

    fill_in 'Description', with: 'description of status'
    fill_in 'Name', with: 'name of status'
    click_on 'Update Initiative status'

    assert_text 'Initiative status was successfully updated'
  end
end
