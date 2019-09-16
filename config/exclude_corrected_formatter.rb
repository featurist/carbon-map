# frozen_string_literal: true

# Custom Rubocop formatter to exclude corrected errors
class ExcludeCorrectedFormatter < RuboCop::Formatter::ProgressFormatter
  def file_finished(file, offenses)
    super(file, offenses.reject(&:corrected?))
  end
end
