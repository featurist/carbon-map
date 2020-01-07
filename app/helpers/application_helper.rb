# frozen_string_literal: true

module ApplicationHelper
  def user_is_admin?
    current_user&.role == 'admin'
  end

  def add_object_link(name, where, render_options)
    html = render(render_options)

    link_to name, '#', onclick: add_object_link_js(where, html)
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

  private

  def add_object_link_js(where, html)
    "
      const index = document.querySelectorAll('.CollectionItem-partial').length
document.getElementById('#{
      where
    }').insertAdjacentHTML('beforeend', `#{
      html
    }`.replace(/(\[\\d*\])/g, `${index}`));return false"
  end
end
