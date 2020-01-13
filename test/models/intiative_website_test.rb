# frozen_string_literal: true

class InitiativeWebsiteTest < ActiveSupport::TestCase
  test 'creating a website without http causes it to be invalid' do
    initiative = Initiative.new
    site = InitiativeWebsite.new(website: 'www.something.com', initiative: initiative)
    assert_not site.valid?
  end

  test 'creating a website with http causes it to be invalid' do
    initiative = Initiative.new
    site1 = InitiativeWebsite.new(website: 'http://www.something.com', initiative: initiative)
    site2 = InitiativeWebsite.new(website: 'https://www.something.com', initiative: initiative)
    assert site1.valid?
    assert site2.valid?
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
