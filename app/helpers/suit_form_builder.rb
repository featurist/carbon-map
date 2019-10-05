# frozen_string_literal: true

# Form builder for adding the necessary .FormField classes
class SuitFormBuilder < ActionView::Helpers::FormBuilder
  def form_field(field, required = false, &block)
    field_errors = object ? object.errors[field] : []

    css_classes = %w[FormField]
    css_classes << 'FormField--required' if required
    css_classes << 'is-error' if field_errors.any?
    # rubocop:disable HelperInstanceVariable
    @template.content_tag :div, class: css_classes, &block
    # rubocop:enable HelperInstanceVariable
  end

  def label(method, text = nil, options = {})
    super(method, text, options.reverse_merge(class: 'FormField-label'))
  end

  def text_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: 'FormField-input'))
  end

  def text_area(attribute, options = {})
    super(
      attribute,
      options.reverse_merge(class: 'FormField-input u-smallMinHeight')
    )
  end

  def number_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: 'FormField-input'))
  end

  def password_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: 'FormField-input'))
  end

  def email_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: 'FormField-input'))
  end

  def date_field(attribute, options = {})
    super(attribute, options.reverse_merge(class: 'FormField-input'))
  end

  def color_field(attribute, options = {})
    super(
      attribute,
      options.reverse_merge(class: 'FormField-custom js-color-input')
    )
  end

  def file_field(attribute, options = {})
    super(
      attribute,
      options.reverse_merge(class: 'FormField-custom js-file-input')
    )
  end
end
