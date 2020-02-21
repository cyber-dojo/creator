# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteCreate200Test < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  # - - - - - - - - - - - - - - - - -

  qtest q31: %w(
  |POST /create_custom_group
  |with a display_name in its request.body
  |that exists in custom-start-points
  |has status 200
  |puts an id: in the response.body
  |which identifies a new group
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    args = { display_name:any_custom_display_name }
    id = assert_json_post_200 '/create_custom_group', args
    assert_group_exists(id, args[:display_name])
  end

  # - - - - - - - - - - - - - - - - -

  qtest q32: %w(
  |POST /create_custom_kata
  |with a display_name in its request.body
  |that exists in custom-start-points
  |has status 200
  |puts an id: in the response.body
  |which identifies a new kata
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    args = { display_name:any_custom_display_name }
    id = assert_json_post_200 '/create_custom_kata', args
    assert_kata_exists(id, args[:display_name])
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

end
