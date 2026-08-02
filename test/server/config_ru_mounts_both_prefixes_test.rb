require_relative 'creator_test_base'
require 'json'
require 'rack/builder'

class ConfigRuMountsBothPrefixesTest < CreatorTestBase
  # The suite normally drives App directly. This test needs the rack app that
  # config.ru builds, because the mount points exist only there.
  def app
    @app ||= Rack::Builder.parse_file(
      File.expand_path('../../source/config/config.ru', __dir__)
    )
  end

  test 'cr8mp1', %w(
  | config.ru serves /alive at both of its mount points: the bare path, which
  | is what nginx's rewrite produces today, and the /creator path, which
  | arrives intact once that rewrite is deleted.
  ) do
    get '/alive'
    assert_equal 200, last_response.status, last_response.body
    assert_equal({ 'alive?' => true }, JSON.parse(last_response.body))

    get '/creator/alive'
    assert_equal 200, last_response.status, last_response.body
    assert_equal({ 'alive?' => true }, JSON.parse(last_response.body))
  end
end
