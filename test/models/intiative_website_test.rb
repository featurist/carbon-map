# frozen_string_literal: true

class InitiativeWebsiteTest < ActiveSupport::TestCase
  test 'creating a website with http at the start adds it for you' do
    site = InitiativeWebsite.new(website: 'www.something.com')
    assert_equal 'https://www.something.com', site.website
  end

  test 'is instagram' do
    site = InitiativeWebsite.new(website: 'https://www.instagram.com/something')
    assert site.instagram?
    assert_not site.facebook?
    assert_not site.twitter?
    assert_not site.youtube?
  end

  test 'is facebook' do
    site = InitiativeWebsite.new(website: 'https://www.facebook.com/something')
    assert_not site.instagram?
    assert site.facebook?
    assert_not site.twitter?
    assert_not site.youtube?
  end

  test 'is twitter' do
    site = InitiativeWebsite.new(website: 'https://twitter.com/something')
    assert_not site.instagram?
    assert_not site.facebook?
    assert site.twitter?
    assert_not site.youtube?
  end

  test 'is youtube' do
    site = InitiativeWebsite.new(website: 'https://www.youtube.com/something')
    assert_not site.instagram?
    assert_not site.facebook?
    assert_not site.twitter?
    assert site.youtube?
  end
end
