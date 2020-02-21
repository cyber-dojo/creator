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
  |and...
  ) do
    # TODO: should be able to stub individual services...
    http_stub(not_json='xxxx')

    assert_json_post_500(
      path='create_custom_group',
      args={ display_name:'Java Countdown, Round 2'}
    ) do |jr|
      assert_equal 'body is not JSON', jr['exception']
    end
  end
=begin
      json_pretty({
        exception:'body is not JSON',
        request: {
          path:path
          #body:args
        },
        service: {
          path:'manifest',
          args:{name:args[:display_name]}, # backwards-compatibility
          name:'ExternalCustomStartPoints',
          body:not_json
        }
      })
=end

end
