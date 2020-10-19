# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class RouteBadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f28
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN4: %w(
  |when an http-proxy
  |returns non-JSON in its response.body
  |it logs the exeption to stdout
  ) do
    stub_model_http('xxxx')
    logs_exception_to_stdout('/ready?')
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when an http-proxy
  |returns JSON (but not a Hash) in its response.body
  |it logs the exception to stdout
  ) do
    stub_model_http('[]')
    logs_exception_to_stdout('/ready?')
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when an http-proxy
  |returns JSON-Hash in its response.body
  |which contains the key "exception"
  |it logs the exception to stdout
  ) do
    stub_model_http(response='{"exception":42}')
    logs_exception_to_stdout('/ready?')
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when an http-proxy
  |returns JSON-Hash in its response.body
  |which does not contain the requested method's key
  |it logs the exception to stdout
  ) do
    stub_model_http(response='{"wibble":42}')
    logs_exception_to_stdout('/ready?')
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN8: %w(
  |when an http-proxy
  |has a 500 error
  |you get the error.erb page
  |and the exception is logged to stdout
  ) do
    stub_exercises_start_points(not_json='xxxx')

    stdout,stderr = capture_io {
      get '/choose_problem',
      {type:'group'}.to_json
    }
    assert status?(500), status
    assert html_content?, content_type
    assert last_response.body.include?('<div id="error-page">')
    assert_equal '', stderr
    json = JSON.parse(stdout)
    ex = json['exception']
    assert_equal '/choose_problem', ex['request']['path'], stdout
    assert_equal '', ex['request']['body'], stdout
    refute_nil ex['backtrace'], stdout
  end

  private

  def stub_exercises_start_points(body)
    externals.instance_exec { @exercises_start_points_http = HttpAdapterStub.new(body) }
  end

  def stub_model_http(body)
    externals.instance_exec { @model_http = HttpAdapterStub.new(body) }
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

  def logs_exception_to_stdout(path)
    stdout,stderr = capture_io { get path }
    assert status?(500), status
    assert json_content?, content_type
    assert_equal '', stderr
    json = JSON.parse(stdout)
    assert_equal [ 'exception' ], json.keys.sort, stdout
  end

end
