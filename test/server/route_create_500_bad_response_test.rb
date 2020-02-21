# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteCreate500BadResponseTest < CreatorTestBase

  def self.id58_prefix
    :f28
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN8: %w(
  |when a co-service POST
  |returns JSON (but not Hash) in its response.body
  |its a 500 error
  |and...
  ) do
    display_name = any_custom_display_name
    http_stub(not_json='xxxx')
    assert_json_post_500 '/create_custom_group', data={ display_name:display_name } do
      json_pretty({exception:"not JSON:#{not_json}"})
    end
  end

end
