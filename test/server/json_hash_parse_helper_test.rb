# frozen_string_literal: true

require_relative 'creator_test_base'
require_source 'json_hash_parse_helper'

class JsonHashParseTest < CreatorTestBase
  def self.id58_prefix
    :k3S
  end

  include JsonHashParseHelper

  # - - - - - - - - - - - - - - - - -

  qtest u70: %w[
    |json_hash_parse
    |returns {}
    |when body is ''
  ] do
    json = json_hash_parse('')
    expected = {}
    assert_equal expected, json
  end

  # - - - - - - - - - - - - - - - - -

  qtest u71: %w[
    |json_hash_parse
    |returns hash
    |when body is a hash
  ] do
    json = json_hash_parse('{"x":42}')
    expected = { 'x' => 42 }
    assert_equal expected, json
  end

  # - - - - - - - - - - - - - - - - -

  qtest u72: %w[
    |json_hash_parse
    |raises RuntimeError
    |when body is not a hash
  ] do
    raised = assert_raises(RuntimeError) {
      json_hash_parse('23')
    }
    assert_equal 'body is not JSON Hash', raised.message
  end

  # - - - - - - - - - - - - - - - - -

  qtest u73: %w[
    |json_hash_parse
    |raises RuntimeError
    |when body is not JSON
  ] do
    raised = assert_raises(RuntimeError) {
      json_hash_parse('}{')
    }
    assert_equal 'body is not JSON', raised.message
  end
end
