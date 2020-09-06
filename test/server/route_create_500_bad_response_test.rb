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
    assert_json_post_500(
      path='group_create_custom',
      args={ display_names:['Java Countdown, Round 2']}
    ) do |response|
      ex = response['exception']
      assert_equal '/group_create_custom', ex['request']['path'], response
      assert_equal '', ex['request']['body'], response
      refute_nil ex['backtrace'], response
      http_service = ex['http_service']
      assert_equal 'body is not JSON', http_service['message'], response
      assert_equal not_json, http_service['body'], response
      assert_equal 'ExternalModel', http_service['name'], response
      assert_equal 'group_create', http_service['path'], response
    end
  end

end
