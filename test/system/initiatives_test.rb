# frozen_string_literal: true

require 'application_system_test_case'

class InitiativesTest < ApplicationSystemTestCase
  setup { @initiative = initiatives(:one) }

  test 'visiting the index' do
    visit initiatives_url
    assert_selector 'h1', text: 'Initiatives'
  end

  test 'creating a Initiative' do
    visit initiatives_url
    click_on 'New Initiative'

    fill_in 'Alternative solution name',
            with: @initiative.alternative_solution_name
    fill_in 'Anticipated carbon saving',
            with: @initiative.anticipated_carbon_saving
    fill_in 'Contact email', with: @initiative.contact_email
    fill_in 'Contact name', with: @initiative.contact_name
    fill_in 'Contact phone', with: @initiative.contact_phone
    check 'Gdpr' if @initiative.gdpr
    check 'Gdpr email verified' if @initiative.gdpr_email_verified
    fill_in 'Image url', with: @initiative.image_url
    fill_in 'Lead group', with: @initiative.lead_group_id
    fill_in 'Locality', with: @initiative.locality
    fill_in 'Location', with: @initiative.location
    fill_in 'Name', with: @initiative.name
    fill_in 'Partner groups role', with: @initiative.partner_groups_role
    fill_in 'Status', with: @initiative.status_id
    fill_in 'Summary', with: @initiative.summary
    click_on 'Create Initiative'

    assert_text 'Initiative was successfully created'
    click_on 'Back'
  end

  test 'updating a Initiative' do
    visit initiatives_url
    click_on 'Edit', match: :first

    fill_in 'Alternative solution name',
            with: @initiative.alternative_solution_name
    fill_in 'Anticipated carbon saving',
            with: @initiative.anticipated_carbon_saving
    fill_in 'Contact email', with: @initiative.contact_email
    fill_in 'Contact name', with: @initiative.contact_name
    fill_in 'Contact phone', with: @initiative.contact_phone
    check 'Gdpr' if @initiative.gdpr
    check 'Gdpr email verified' if @initiative.gdpr_email_verified
    fill_in 'Image url', with: @initiative.image_url
    fill_in 'Lead group', with: @initiative.lead_group_id
    fill_in 'Locality', with: @initiative.locality
    fill_in 'Location', with: @initiative.location
    fill_in 'Name', with: @initiative.name
    fill_in 'Partner groups role', with: @initiative.partner_groups_role
    fill_in 'Status', with: @initiative.status_id
    fill_in 'Summary', with: @initiative.summary
    click_on 'Update Initiative'

    assert_text 'Initiative was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Initiative' do
    visit initiatives_url
    page.accept_confirm { click_on 'Destroy', match: :first }

    assert_text 'Initiative was successfully destroyed'
  end
end
