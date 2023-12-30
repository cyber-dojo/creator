require 'simplecov'
require_relative 'simplecov-json'

$CODE_DIR = ENV['CODE_DIR']
$TEST_DIR = ENV['TEST_DIR']

SimpleCov.start do
  enable_coverage(:branch)
  filters.clear
  add_filter("/usr/")
  coverage_dir(ENV['COVERAGE_ROOT'])
  #add_group('debug') { |src| puts(src.filename); false }
  add_group($CODE_DIR) { |src| src.filename !~ %r"test" }
  add_group($TEST_DIR) { |src| src.filename =~ %r"test" }
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])
