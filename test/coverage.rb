require 'simplecov'
require_relative 'simplecov_json'
require_relative 'runs_text_reporter'

SimpleCov.start do
  enable_coverage(:branch)
  filters.clear
  coverage_dir(ENV['COVERAGE_ROOT'])
  # add_group('debug') { |src| puts(src.filename); false }
  add_group('app')  { |src| src.filename !~ /test/ }
  add_group('test') { |src| src.filename =~ /test/ }
end

formatters = [SimpleCov::Formatter::HTMLFormatter,
              SimpleCov::Formatter::JSONFormatter]
SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new(formatters)

Minitest::Reporters.use!([
  RunsTextReporter.new,
  Minitest::Reporters::JUnitReporter.new("#{ENV.fetch('COVERAGE_ROOT')}/junit")
])
