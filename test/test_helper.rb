# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'vcr'
require 'webmock/minitest'

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def sign_in_as(key, with_password: 'password')
      user = users key
      post user_session_url params: {
        user: {
          email: user.email, password: with_password
        }
      }
    end

    VCR.configure do |config|
      config.cassette_library_dir = 'test/vcr_cassettes'
      config.hook_into :webmock
      config.ignore_localhost = true
      config.ignore_hosts 'chromedriver.storage.googleapis.com',
                          'zams.platform.localhost'
    end
  end
end
