require 'simplecov'
require_relative 'simplecov-json'

SimpleCov.start do
  enable_coverage(:branch)
  filters.clear
  add_filter("/usr/")
  coverage_dir(ENV['COVERAGE_ROOT'])
  #add_group('debug') { |src| puts(src.filename); false }
  code_dir = ENV['CODE_DIR']
  test_dir = ENV['TEST_DIR']
  add_group(code_dir) { |src| src.filename =~ %r"^/app/#{code_dir}/" }
  add_group(test_dir) { |src| src.filename =~ %r"^/app/#{test_dir}/.*_test\.rb$" }
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])
