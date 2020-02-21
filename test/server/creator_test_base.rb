# frozen_string_literal: true
require_relative 'capture_stdout_stderr'
require_relative '../id58_test_base'
require_src 'app'
require_src 'externals'
require_src 'creator'
require_src 'id_pather'
require 'json'

class CreatorTestBase < Id58TestBase
  include Rack::Test::Methods # [1]
  include CaptureStdoutStderr

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def creator
    @creator ||= Creator.new(externals)
  end

  def app # [1]
    @app ||= App.new(creator)
  end

  # - - - - - - - - - - - - - - - -

  def assert_get_200(path)
    stdout,stderr = capture_stdout_stderr { get path }
    assert_status 200
    assert_equal '', stderr
    assert_equal '', stdout
    key = path[1..-1] # lose leading /
    assert json_response.has_key?(key)
    json_response[key]
  end

  def assert_json_post_200(path, args)
    stdout,stderr = capture_stdout_stderr { json_post path, args }
    assert_status 200
    assert_equal '', stderr
    assert_equal '', stdout
    key = path[1..-1] # lose leading /
    assert json_response.has_key?(key)
    json_response[key]
  end

  # - - - - - - - - - - - - - - - -

  def assert_get_500(path)
    stdout,stderr = capture_stdout_stderr { get path }
    assert_status 500
    assert_equal '', stderr
    key = path[1..-1] # lose leading /
    refute json_response.has_key?(key)
    if block_given?
      expected_diagnostic = yield
      assert_equal expected_diagnostic, stdout, :stdout
      assert_equal expected_diagnostic, last_response.body, :last_response_body
    end
  end

  def assert_json_post_500(path, args) # &block)
    stdout,stderr = capture_stdout_stderr { json_post path, args }
    assert_status 500
    assert_equal '', stderr
    if block_given?
      expected_diagnostic = yield
      assert_equal expected_diagnostic+"\n", stdout, :stdout
      assert_equal expected_diagnostic, last_response.body, :last_response_body
    end
  end

  def assert_status(expected)
    assert_equal expected, last_response.status, :last_response_status
  end

  # - - - - - - - - - - - - - - - -

  def any_custom_display_name
    custom.display_names.sample
  end

  def json_post(path, data)
    post path, data.to_json, JSON_REQUEST_HEADERS
  end

  def json_response
    JSON.parse(last_response.body)
  end

  def json_pretty(o)
    JSON.pretty_generate(o)
  end

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => 'application/json', # sent request
    'HTTP_ACCEPT' => 'application/json'   # received response
  }

  # - - - - - - - - - - - - - - - -

  def group_exists?(id)
    saver.exists?(group_id_path(id))
  end

  def kata_exists?(id)
    saver.exists?(kata_id_path(id))
  end

  # - - - - - - - - - - - - - - - -

  def http_stub(body)
    externals.instance_exec { @http = HttpAdapterStub.new(body) }
  end

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def post(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

  private

  include IdPather

  def custom
    externals.custom_start_points
  end

  def saver
    externals.saver
  end

end
