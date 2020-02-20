# frozen_string_literal: true
require_relative 'creator_test_base'

class CreatorTest200 < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  # - - - - - - - - - - - - - - - - -

  qtest q31: %w(
  |POST /create_custom_group
  |with a valid display_name in the JSON-Request body
  |has status 200 and
  |creates a group
  |whose manifest matches the display_name
  |whose id is in the JSON-Response body
  ) do
    args = { display_name:any_custom_display_name }
    stdout = capture_stdout { json_post '/create_custom_group', args }
    assert_status(200)
    assert_group_exists(id_from_json_response, args[:display_name])
    assert_equal '', stdout
  end

  # - - - - - - - - - - - - - - - - -

  qtest q32: %w(
  |POST /create_custom_kata
  |with a valid display_name in the JSON-Request body
  |has status 200 and
  |creates a kata
  |whose manifest matches the display_name
  |whose id is in the JSON-Response body
  ) do
    args = { display_name:any_custom_display_name }
    stdout = capture_stdout { json_post '/create_custom_kata', args }
    assert_status(200)
    assert_kata_exists(id_from_json_response, args[:display_name])
    assert_equal '', stdout
  end

  private

  def assert_group_exists(id, display_name)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def assert_kata_exists(id, display_name)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def group_manifest(id)
    JSON::parse!(saver.read("#{group_id_path(id)}/manifest.json"))
  end

  def kata_manifest(id)
    JSON::parse!(saver.read("#{kata_id_path(id)}/manifest.json"))
  end

  def id_from_json_response
    json_response['id'] # backwards compatibility!
  end

end
