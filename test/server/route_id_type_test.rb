# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteIdTypeTest < CreatorTestBase

  def self.id58_prefix
    :qed
  end

  # - - - - - - - - - - - - - - - - -

  qtest x23: %w(
  |GET /id_type
  |has status 200
  |returns 'group'
  |when id is of an existing group
  ) do
    assert_get_200_json('id_type?id=chy6BJ') do |response|
      assert_equal ['id_type'], response.keys, last_response.body
      id_type = response['id_type']
      assert_equal 'group', id_type
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest x24: %w(
  |GET /id_type
  |has status 200
  |returns 'single'
  |when id is of an existing kata
  ) do
    assert_get_200_json('id_type?id=5rTJv5') do |response|
      assert_equal ['id_type'], response.keys, last_response.body
      id_type = response['id_type']
      assert_equal 'single', id_type
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest x25: %w(
  |GET /id_type
  |has status 200
  |returns nil
  |when id is neither a group nor a kata
  ) do
    assert_get_200_json('id_type?id=x1y2z3') do |response|
      assert_equal ['id_type'], response.keys, last_response.body
      id_type = response['id_type']
      assert_nil id_type
    end
  end

end
