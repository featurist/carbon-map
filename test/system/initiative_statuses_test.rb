# frozen_string_literal: true

require 'application_system_test_case'

class InitiativeStatusesTest < ApplicationSystemTestCase
  setup do
    @initiative_status = initiative_statuses(:one)
  end

  test 'visiting the index' do
    visit initiative_statuses_url
    assert_selector 'h1', text: 'Initiative Statuses'
  end

  test 'creating a Initiative status' do
    visit initiative_statuses_url
    click_on 'New Initiative Status'

    fill_in 'Description', with: @initiative_status.description
    fill_in 'Name', with: @initiative_status.name
    click_on 'Create Initiative status'

    assert_text 'Initiative status was successfully created'
    click_on 'Back'
  end

  test 'updating a Initiative status' do
    visit initiative_statuses_url
    click_on 'Edit', match: :first

    fill_in 'Description', with: @initiative_status.description
    fill_in 'Name', with: @initiative_status.name
    click_on 'Update Initiative status'

    assert_text 'Initiative status was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Initiative status' do
    visit initiative_statuses_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Initiative status was successfully destroyed'
  end
end
