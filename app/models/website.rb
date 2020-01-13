# frozen_string_literal: true

module Website
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

  def icon
    return :instagram if instagram?
    return :facebook if facebook?
    return :twitter if twitter?
    return :youtube if youtube?

    :link
  end
end
