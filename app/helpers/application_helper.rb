# frozen_string_literal: true

module ApplicationHelper
  def user_is_admin?
    current_user&.role == 'admin'
  end

  def add_object_link(name, id, render_options)
    html = render(render_options)

    link_to name, '#', onclick: add_object_link_js(id, html), class: 'Button--link'
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

  def variant_url(variant)
    Rails.application.routes.url_helpers.rails_representation_url(
      variant,
      Rails.application.config.action_mailer.default_url_options
    )
  end

  def og_logo
    {
      _: asset_pack_url('media/images/logo.png'),
      width: 200,
      height: 200
    }
  end

  def initiative_carbon_text(initiative)
    text = 'Carbon Saving not applicable'
    if initiative.carbon_saving_anticipated?
      if initiative.carbon_saving_quantified?
        text = "Direct Carbon Saving: #{format_carbon_saving(initiative.carbon_saving_amount)}"
      end
      text = 'Carbon Saving not yet quantified' unless initiative.carbon_saving_quantified?
    end
    text
  end

  # rubocop:disable Rails/HelperInstanceVariable
  def breadcrumb(items)
    @breadcrumb_items = items
  end
  # rubocop:enable Rails/HelperInstanceVariable

  def can_edit_initiative?(initiative)
    initiative.owner == current_user || current_user&.role == 'admin'
  end

  private

  def add_object_link_js(id, html)
    "const index = document.querySelectorAll('#websites tr').length
    document.querySelector('##{id} tbody').insertAdjacentHTML('beforeend', `#{
      html
    }`.replace(/(\[\\d*\])/g, `${index}`));return false"
  end
end
