# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteCreate500BadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f28
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN8: %w(
  |when a co-service
  |returns JSON (but not Hash) in its response.body
  |its a 500 error
  ) do
    stub_model_http(not_json='xxxx')
    assert_json_post_500(
      path='group_create_custom',
      args={ display_names:['Java Countdown, Round 2']}
    ) do |jr|
      ex = jr['exception']
      assert_equal '/group_create_custom', ex['request']['path'], jr
      assert_equal '', ex['request']['body'], jr
      refute_nil ex['backtrace'], jr
      http_service = ex['http_service']
      assert_equal 'body is not JSON', http_service['message'], jr
      assert_equal not_json, http_service['body'], jr
      assert_equal 'ExternalModel', http_service['name'], jr
      assert_equal 'group_create', http_service['path'], jr
    end
  end

end
