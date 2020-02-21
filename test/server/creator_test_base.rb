# frozen_string_literal: true
require_relative 'capture_stdout'
require_relative '../id58_test_base'
require_src 'app'
require_src 'externals'
require_src 'creator'
require_src 'id_pather'
require 'json'

class CreatorTestBase < Id58TestBase
  include Rack::Test::Methods
  include CaptureStdout

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def creator
    @creator ||= Creator.new(externals)
  end

  def app
    @app ||= App.new(creator)
  end

  # - - - - - - - - - - - - - - - -

  def get_200(path)
    get path
    assert_status(200)
    json_response[path[1..-1]]
  end

  def get_500(path)
    get path
    assert_status(500)
    assert_nil json_response[path[1..-1]]
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

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => 'application/json',  # sent request
    'HTTP_ACCEPT' => 'application/json'    # received response
  }

  def assert_status(expected)
    assert_equal expected, last_response.status, :last_response_status
  end

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
