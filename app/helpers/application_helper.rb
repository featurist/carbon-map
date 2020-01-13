# frozen_string_literal: true

module ApplicationHelper
  def user_is_admin?
    current_user&.role == 'admin'
  end

  def add_object_link(name, render_options)
    html = render(render_options)

    link_to name, '#', onclick: add_object_link_js(html), class: 'Button Button--primary'
  end

  def admin_path
    '/admin'
  end

  def format_carbon_saving(value)
    "#{number_with_delimiter(value, delimiter: ',')} #{carbon_units}"
  end

  def carbon_units
    'kgCO2e/yr'
  end

  def inline_icon(name)
    # rubocop:disable Rails/OutputSafety
    File.readlines("frontend/icons/#{name}.svg").join('').html_safe
    # rubocop:enable Rails/OutputSafety
  end

  private

  def add_object_link_js(html)
    "const index = document.querySelectorAll('#websites tr').length
    document.querySelector('#websites tbody').insertAdjacentHTML('beforeend', `#{
      html
    }`.replace(/(\[\\d*\])/g, `${index}`));return false"
  end
end
