# frozen_string_literal: true

# Form builder for adding the necessary .FormField classes
class SuitFormBuilder < ActionView::Helpers::FormBuilder
  def form_field(field, options = {}, &block)
    field_errors = object ? object.errors[field] : []
    required = options[:required] || false

    css_classes = %w[FormField]
    css_classes << 'FormField--required' if required
    css_classes << 'is-error' if field_errors.any?
    css_classes << options[:class_names]
    # rubocop:disable HelperInstanceVariable
    @template.content_tag :div, class: css_classes, &block
    # rubocop:enable HelperInstanceVariable
  end

  def label(method, options_or_text = {})
    if options_or_text.class == String
      text = options_or_text
      options = {}
    else
      options = options_or_text
      text = options_or_text[:text]
    end
    css_classes = %w[FormField-label]
    css_classes << options[:class_name]
    super(method, text, options.reverse_merge(class: css_classes))
  end

  def text_field(attribute, options = {})
    class_names = %w[FormField-input]
    class_names << options.delete(:class_names) if options[:class_names]
    super(attribute, options.reverse_merge(class: class_names))
  end

  def text_area(attribute, options = {})
    super(
      attribute,
      options.reverse_merge(class: 'FormField-input')
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
