# frozen_string_literal: true

require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  def self.js?
    ENV['JS'] || ENV['GUI']
  end

  def self.ac_lens_sftp?
    ENV['AC_LENS_SFTP']
  end

  driver = js? ? :selenium : :rack_test

  driven_by driver,
            using: ENV['GUI'] ? :chrome : :headless_chrome,
            screen_size: [1_400, 1_400]

  def sign_in_as(user_fixture_name)
    user = users user_fixture_name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'password'
    click_on 'Log in'
  end
end
