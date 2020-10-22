# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class ForkingTest < CreatorTestBase #!

  def self.id58_prefix
    :d5T
  end

  # - - - - - - - - - - - - - - - - -

  qtest x9A: %w(
  |fork a new individual exercie
  |from version-0 kata
  |that is in a group (dolphin)
  ) do
    post "/fork_individual?id=k5ZTk0&index=2", '{}', JSON_REQUEST_HEADERS

    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    json = JSON.parse(last_response.body)
    id = json['id']
    #print id
  end

end
