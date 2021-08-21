require_relative '../id58_test_base'
require 'capybara/minitest'
require_source 'externals'

class CreatorTestBase < Id58TestBase

  include Capybara::DSL
  include Capybara::Minitest::Assertions

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app,
      browser: :remote,
      url: 'http://selenium:4444/wd/hub',
      desired_capabilities: :firefox
    )
  end

  def setup
    Capybara.app_host = 'http://nginx:80'
    Capybara.javascript_driver = :selenium
    Capybara.current_driver    = :selenium
    Capybara.run_server = false
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.app_host = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def group_exists?(id)
    saver.group_exists?(id)
  end

  def group_manifest(id)
    saver.group_manifest(id)
  end

  def kata_exists?(id)
    saver.kata_exists?(id)
  end

  def kata_manifest(id)
    saver.kata_manifest(id)
  end

  # - - - - - - - - - - - - - - - - - - -

  def any_custom_start_points_display_name
    custom_start_points.names.sample
  end

  # - - - - - - - - - - - - - - - - - - -

  def creator
    externals.creator
  end

  def custom_start_points
    externals.custom_start_points
  end

  def saver
    externals.saver
  end

  # - - - - - - - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

end
