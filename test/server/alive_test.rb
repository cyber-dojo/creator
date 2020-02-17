# frozen_string_literal: true
require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.id58_prefix
    'a87'
  end

  # - - - - - - - - - - - - - - - - -

  test '15d', %w( GET /alive returns JSON'd true ) do
    get '/alive'
    assert_status(SUCCESS)
    assert true?(json_response['alive?']), last_response.body
  end

end
