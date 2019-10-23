# frozen_string_literal: true

require 'application_system_test_case'

class GroupWebsitesTest < ApplicationSystemTestCase
  setup { @group_website = group_websites(:one) }

  test 'visiting the index' do
    visit group_websites_url
    assert_selector 'h1', text: 'Group Websites'
  end

  test 'creating a Group website' do
    visit group_websites_url
    click_on 'New Group Website'

    fill_in 'Group', with: @group_website.group
    fill_in 'Website', with: @group_website.website
    click_on 'Create Group website'

    assert_text 'Group website was successfully created'
    click_on 'Back'
  end

  test 'updating a Group website' do
    visit group_websites_url
    click_on 'Edit', match: :first

    fill_in 'Group', with: @group_website.group
    fill_in 'Website', with: @group_website.website
    click_on 'Update Group website'

    assert_text 'Group website was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Group website' do
    visit group_websites_url
    page.accept_confirm { click_on 'Destroy', match: :first }

    assert_text 'Group website was successfully destroyed'
  end
end
