# frozen_string_literal: true

class InitiativeWebsiteTest < ActiveSupport::TestCase
  test 'creating a website without http causes it to be invalid' do
    initiative = Initiative.new
    site = InitiativeWebsite.new(url: 'www.something.com', initiative: initiative)
    assert_not site.valid?
  end

  test 'creating a website with http causes it to be invalid' do
    initiative = Initiative.new
    site1 = InitiativeWebsite.new(url: 'http://www.something.com', initiative: initiative)
    site2 = InitiativeWebsite.new(url: 'https://www.something.com', initiative: initiative)
    assert site1.valid?
    assert site2.valid?
  end

  test 'is instagram' do
    site = InitiativeWebsite.new(url: 'https://www.instagram.com/something')
    assert site.instagram?
    assert_not site.facebook?
    assert_not site.twitter?
    assert_not site.youtube?
  end

  test 'is facebook' do
    site = InitiativeWebsite.new(url: 'https://www.facebook.com/something')
    assert_not site.instagram?
    assert site.facebook?
    assert_not site.twitter?
    assert_not site.youtube?
  end

  test 'is twitter' do
    site = InitiativeWebsite.new(url: 'https://twitter.com/something')
    assert_not site.instagram?
    assert_not site.facebook?
    assert site.twitter?
    assert_not site.youtube?
  end

  test 'is youtube' do
    site = InitiativeWebsite.new(url: 'https://www.youtube.com/something')
    assert_not site.instagram?
    assert_not site.facebook?
    assert_not site.twitter?
    assert site.youtube?
  end
end
