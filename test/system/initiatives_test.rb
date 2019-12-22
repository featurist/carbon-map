# frozen_string_literal: true

require 'application_system_test_case'

class InitiativesTest < ApplicationSystemTestCase
  test 'visiting the index' do
    visit initiatives_url
    sign_in_as :georgie
    assert_selector 'h1', text: 'Initiatives'
  end

  if js?
    test 'creating a Initiative' do
      visit initiatives_url
      sign_in_as :georgie
      click_on 'New Initiative'

      fill_in 'Name', with: 'Initiative name', match: :first
      fill_in 'Summary', with: 'Summary'
      fill_in 'Anticipated carbon saving', with: '200'
      fill_in 'Contact email', with: 'contact@test.com', match: :first
      fill_in 'Contact name', with: 'contact name', match: :first
      fill_in 'Contact phone', with: 'contact phone', match: :first
      select 'Down to Earth Stroud', from: 'Lead group'
      fill_in 'Postcode', with: 'Postcode'
      fill_in 'Partner groups role', with: 'Partner role'
      select 'Operational', from: 'Status'
      click_on 'Energy'
      click_by_title 'Add Heating'
      click_on 'Create Initiative'

      assert_text 'Initiative was successfully created'
    end

    test 'updating a Initiative' do
      visit initiatives_url
      sign_in_as :georgie
      click_on 'Edit', match: :first

      fill_in 'Name', with: 'Initiative name', match: :first
      fill_in 'Summary', with: 'Summary'
      fill_in 'Anticipated carbon saving', with: '200'
      fill_in 'Contact email', with: 'contact@test.com', match: :first
      fill_in 'Contact name', with: 'contact name', match: :first
      fill_in 'Contact phone', with: 'contact phone', match: :first
      select 'Down to Earth Stroud', from: 'Lead group'
      fill_in 'Postcode', with: 'Postcode'
      fill_in 'Partner groups role', with: 'Partner role'
      select 'Operational', from: 'Status'
      click_on 'Update Initiative'

      assert_text 'Initiative was successfully updated'
    end
  end

  def click_by_title(title)
    find("a[title='#{title}']").click
  end
end
