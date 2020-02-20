# frozen_string_literal: true
require_relative 'creator_test_base'

class Creator500BadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f28
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN4: %w(
  |when a co-service GET
  |returns non-JSON in its response.body
  |its a 500 error
  |and...
  ) do
    http_stub('xxxx')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when a co-service GET
  |returns JSON (but not a Hash) in its response.body
  |its a 500 error
  |and...
  ) do
    http_stub('[]')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which contains a key "exception"
  |its a 500 error
  |and...
  ) do
    http_stub('{"exception":42}')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which does not contain a key for the called method
  |its a 500 error
  |and...
  ) do
    http_stub('{"wibble":42}')
    _stdout = capture_stdout { get '/ready' }
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN8: %w(
  |when a co-service POST
  |returns JSON (but not Hash) in its response.body
  |its a 500 error
  |and...
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
