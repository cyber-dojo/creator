# frozen_string_literal: true
require_relative 'creator_test_base'

class Creator500BadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN4', %w(
  co-service GET returns non-JSON in response.body
  is 500 error
  ) do
    http_stub('xxxx')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN5', %w(
  co-service GET returns JSON (but not Hash) response.body
  is 500 error
  ) do
    http_stub('[]')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN6', %w(
  co-service GET returns JSON-Hash response.body
  containing exception key
  is 500 error
  ) do
    http_stub('{"exception":42}')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN7', %w(
  co-service GET returns JSON-Hash response.body
  not containing key for method
  is 500 error
  ) do
    http_stub('{"wibble":42}')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  test 'QN8', %w(
  co-service POST returns JSON (but not Hash) in response.body
  is 500 error
  ) do
    display_name = any_custom_display_name
    http_stub('xxxx')
    _stdout = capture_stdout {
      json_post '/create_custom_group', data = {
        display_name:display_name
      }
    }
    assert_status(500)
  end

  private

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

end
