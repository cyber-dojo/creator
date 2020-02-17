# frozen_string_literal: true
require_relative 'creator_test_base'

class CreatorTest < CreatorTestBase

  def self.id58_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '702', %w(
  POST /create_custom_group?display_name=VALID
  causes 302 redirect to /kata/group/:id
  and a group with :id exists
  and its manifest matches the display_name
  ) do
    post '/create_custom_group', data={ display_name:any_custom_display_name }
    assert_status(TEMPORARY_REDIRECT)
    follow_redirect!
    assert_group_exists(id_from_group_url, data[:display_name])
  end

  # - - - - - - - - - - - - - - - - -

  test '703', %w(
  POST /create_custom_kata?display_name=VALID
  causes 302 redirect to kata/edit/:id
  and a kata with :id exists
  and its manifest matches the display_name
  ) do
    post '/create_custom_kata', data={ display_name:any_custom_display_name }
    assert_status(TEMPORARY_REDIRECT)
    follow_redirect!
    assert_kata_exists(id_from_kata_url, data[:display_name])
  end

  # - - - - - - - - - - - - - - - - -

  test 'q31', %w(
  POST /create_custom_group,
  with a valid display_name in the JSON-Request body,
  creates a group,
  whose manifest matches the display_name,
  whose id is in the JSON-Response body
  ) do
    data = { display_name:any_custom_display_name }
    post '/create_custom_group', data.to_json, JSON_REQUEST_HEADERS
    assert_status(SUCCESS)
    assert_group_exists(id_from_json_response, data[:display_name])
  end

  # - - - - - - - - - - - - - - - - -

  test 'q32', %w(
  POST /create_custom_kata,
  with a valid display_name in the JSON-Request body,
  creates a kata,
  whose manifest matches the display_name,
  whose id is in the JSON-Response body
  ) do
    data = { display_name:any_custom_display_name }
    post '/create_custom_kata', data.to_json, JSON_REQUEST_HEADERS
    assert_status(SUCCESS)
    assert_kata_exists(id_from_json_response, data[:display_name])
  end

  # - - - - - - - - - - - - - - - - -

  test '603', %w(
    POST /create_custom_group?display_name=INVALID,
    ...
  ) do
    post '/create_custom_group', data={ display_name:'invalid' }
    #puts "status:#{last_response.status}:" # 500
    # but response.body needs to get json { "exception":"...." }
  end

  # - - - - - - - - - - - - - - - - -

  test 'q33', %w(
  POST /create_custom_group,
  with an invalid display_name in the JSON-Request body,
  ...
  ) do
    data = { display_name:'invalid' }
    post '/create_custom_group', data.to_json, JSON_REQUEST_HEADERS
    #puts "status:#{last_response.status}:" # 500 
  end

  private

  def any_custom_display_name
    custom.display_names.sample
  end

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

  def id_from_group_url
    match = last_request.url.match(%r{http://example.org/kata/group/(.*)})
    assert match, "did not match #{last_request.url}"
    match[1]
  end

  def id_from_kata_url
    match = last_request.url.match(%r{http://example.org/kata/edit/(.*)})
    assert match, "did not match #{last_request.url}"
    match[1]
  end

  def id_from_json_response
    json_response['id']
  end

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => 'application/json',  # sent in request
    'HTTP_ACCEPT' => 'application/json'    # received in response
  }

end
