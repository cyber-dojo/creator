require 'simplecov'

app_root = File.expand_path('../..', __dir__)
SimpleCov.start do
  add_group( 'src') { | src|
    src.filename.start_with?("#{app_root}") &&
    !src.filename.start_with?("#{app_root}/test")      
  }
  add_group('test') { |test|
    test.filename.start_with?("#{app_root}/test")
  }
end
SimpleCov.root(app_root)
SimpleCov.coverage_dir(ENV['COVERAGE_ROOT'])
