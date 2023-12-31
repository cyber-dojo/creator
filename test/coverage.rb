require 'simplecov'
require_relative 'simplecov-json'

SimpleCov.start do
  enable_coverage(:branch)
  filters.clear
  coverage_dir(ENV['COVERAGE_ROOT'])
  #add_group('debug') { |src| puts(src.filename); false }
  add_group('app')  { |src| src.filename !~ %r"test" }
  add_group('test') { |src| src.filename =~ %r"test" }
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])
