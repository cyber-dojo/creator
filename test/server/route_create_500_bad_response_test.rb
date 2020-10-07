# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteCreate500BadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f28
  end

  # - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - -

  qtest QN4: %w(
  |when an http-proxy
  |returns non-JSON in its response.body
  |its a 500 error
  ) do
    stub_model_http('xxxx')
    assert_get_500('ready?') do |response|
      assert_equal [ 'exception' ], response.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when an http-proxy
  |returns JSON (but not a Hash) in its response.body
  |its a 500 error
  ) do
    stub_model_http('[]')
    assert_get_500('ready?') do |response|
      assert_equal [ 'exception' ], response.keys.sort, last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when an http-proxy
  |returns JSON-Hash in its response.body
  |which contains the key "exception"
  |its a 500 error
  ) do
    stub_model_http(response='{"exception":42}')
    assert_get_500('ready?') do |response|
      assert_equal [ 'exception' ], response.keys.sort, last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when an http-proxy
  |returns JSON-Hash in its response.body
  |which does not contain the requested method's key
  |its a 500 error
  ) do
    stub_model_http(response='{"wibble":42}')
    assert_get_500('ready?') do |response|
      assert_equal [ 'exception' ], response.keys.sort, last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN8: %w(
  |when an http-proxy
  |has a 500 error
  |there is useful diagnostic info
  ) do
    stub_model_http(not_json='xxxx')

    stdout,stderr = capture_io {
      get '/group_custom_create',
      {display_name:'Java Countdown, Round 2'}.to_json
    }
    assert status?(500), status
    assert json_content?, content_type
    assert_equal '', stderr, :stderr
    assert_equal stdout, last_response.body+"\n", :stdout
    ex = json_response['exception']
    assert_equal '/group_custom_create', ex['request']['path'], json_response
    assert_equal '', ex['request']['body'], json_response
    refute_nil ex['backtrace'], json_response
    assert_equal 'missing keyword: :display_name', ex['message'], json_response
  end

end
