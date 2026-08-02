require_relative '../id58_test_base'
require 'capybara/minitest'

# The client container mounts its own tree at /app/source, so its ruby sits
# flat there. The server's container nests the app one level deeper, which is
# why each suite defines this rather than sharing one definition.
def require_source(required)
  require_relative "../../source/#{required}"
end

require_source 'externals'

class CreatorTestBase < Id58TestBase
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  # The client app lives in the CreatorClient namespace. Including it here puts
  # that module in the ancestor chain of every client test class, so tests name
  # Externals and HttpJsonHash::ServiceError unqualified.
  include CreatorClient

  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app,
                                   browser: :remote,
                                   url: 'http://selenium:4444/wd/hub',
                                   capabilities: :firefox)
  end

  def setup
    Capybara.app_host = 'http://nginx_stub:80'
    Capybara.javascript_driver = :selenium
    Capybara.current_driver    = :selenium
    Capybara.run_server = false
  end

  def teardown
    Capybara.reset_sessions!
    Capybara.app_host = nil
  end

  # - - - - - - - - - - - - - - - - - - -

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def any_exercises_start_points_display_name
    exercises_start_points.names.sample
  end

  # - - - - - - - - - - - - - - - - - - -

  def creator
    externals.creator
  end

  def custom_start_points
    externals.custom_start_points
  end

  def exercises_start_points
    externals.exercises_start_points
  end

  def languages_start_points
    externals.languages_start_points
  end

  def saver
    externals.saver
  end

  # - - - - - - - - - - - - - - - - - - -

  def true?(obj)
    obj.is_a?(TrueClass)
  end
end
