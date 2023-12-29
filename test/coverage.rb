require 'simplecov'
require_relative 'simplecov-json'

$CODE_DIR = ENV['CODE_DIR']
$TEST_DIR = ENV['TEST_DIR']

def is_code_file?(filename)
  filename =~ %r"^/#{$CODE_DIR}/.*\.rb$"
end

def is_test_file?(filename)
  filename =~ %r"^/#{$CODE_DIR}/#{$TEST_DIR}/.*_test\.rb$"
end

SimpleCov.start do
  enable_coverage(:branch)
  filters.clear
  add_filter("/usr/")
  coverage_dir(ENV['COVERAGE_ROOT'])
  # add_group('debug') { |src| puts(src.filename); false }
  add_group($CODE_DIR) { |src|
    is_code_file?(src.filename) && !is_test_file?(src.filename)
  }
  add_group($TEST_DIR) { |src|
    is_test_file?(src.filename)
  }
end

SimpleCov.formatters = SimpleCov::Formatter::MultiFormatter.new([
  SimpleCov::Formatter::HTMLFormatter,
  SimpleCov::Formatter::JSONFormatter,
])
