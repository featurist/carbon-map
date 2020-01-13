# frozen_string_literal: true

module Website
  def website=(value)
    value = value.strip
    value = 'https://' + value unless value.start_with? 'http'

    self[:website] = value
  end

  def instagram?
    website.start_with? 'https://www.instagram.com'
  end

  def facebook?
    website.start_with? 'https://www.facebook.com'
  end

  def twitter?
    website.start_with? 'https://twitter.com'
  end

  def youtube?
    website.start_with? 'https://www.youtube.com'
  end
end
