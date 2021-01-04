# frozen_string_literal: true
require_relative 'creator_test_base'

class DeprecatedCreateTest < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  def id58_setup
    @display_name = any_custom_start_points_display_name
    @exercise_name = any_exercises_start_points_display_name
    @language_name = any_languages_start_points_display_name
  end

  attr_reader :display_name, :exercise_name, :language_name

  # - - - - - - - - - - - - - - - - -

  qtest De1: %w(
  |POST /deprecated_group_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_post_200_json(
      path = 'deprecated_group_create_custom',
      args = { display_name:display_name }
    ) do |response|
      assert_equal [path,'id'], response.keys.sort, :keys
      assert_group_exists(response['id'], display_name)
      assert_equal response[path], response['id'], :id
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest De2: %w(
  |POST /deprecated_kata_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_post_200_json(
      path = 'deprecated_kata_create_custom',
      args = { display_name:display_name }
    ) do |response|
      assert_equal [path,'id'], response.keys.sort, :keys
      assert_kata_exists(response['id'], display_name)
      assert_equal response[path], response['id'], :id
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest De3: %w(
  |POST /deprecated_kata_create_custom
  |with body that is non JSON
  |logs to stdout
  ) do
    stdout,stderr = capture_io {
      post '/deprecated_kata_create_custom',
      'not-JSON',
      JSON_REQUEST_HEADERS
    }
    assert_equal '', stderr, :stderr
    json_stdout = JSON.parse(stdout)
    ex = json_stdout['exception']
    assert_equal '/deprecated_kata_create_custom', ex['request']['path'], stdout
    assert_equal '', ex['request']['body'], stdout
    refute_nil ex['backtrace'], stdout
    assert_equal 'body is not JSON', ex['message'], stdout
  end

  # - - - - - - - - - - - - - - - - -

  qtest De4: %w(
  |POST /deprecated_kata_create_custom
  |with body that is non JSON-Hash
  |logs to stdout
  ) do
    stdout,stderr = capture_io {
      post '/deprecated_kata_create_custom',
      '[42]',
      JSON_REQUEST_HEADERS
    }
    assert_equal '', stderr, :stderr
    json_stdout = JSON.parse(stdout)
    ex = json_stdout['exception']
    assert_equal '/deprecated_kata_create_custom', ex['request']['path'], stdout
    assert_equal '', ex['request']['body'], stdout
    refute_nil ex['backtrace'], stdout
    assert_equal 'body is not JSON Hash', ex['message'], stdout
  end

  private

  def assert_group_exists(id, display_name)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    assert manifest.has_key?('exercise')
    assert_equal '', manifest['exercise'], :polyfilled
  end

  def assert_kata_exists(id, display_name)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    assert manifest.has_key?('exercise')
    assert_equal '', manifest['exercise'], :polyfilled
  end

end
