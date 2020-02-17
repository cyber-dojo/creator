# frozen_string_literal: true
require_relative 'creator_test_base'

class CreatorTest < CreatorTestBase

  def self.id58_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '702', %w(
  POST /create_custom_group?display_name=VALID
  causes redirect to /kata/group/:id
  and a group with :id exists
  and its manifest matches the display_name
  ) do
    display_name = custom.display_names.sample
    post '/create_custom_group', display_name:display_name
    assert_equal 302, last_response.status, :last_response_status
    follow_redirect!
    match = last_request.url.match(%r{http://example.org/kata/group/(.*)})
    assert match, "did not match #{last_request.url}"
    id = match[1]
    assert group_exists?(id), "group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  # - - - - - - - - - - - - - - - - -

  test '703', %w(
  POST /create_custom_kata?display_name=VALID
  causes redirect to kata/edit/:id
  and a kata with :id exists
  and its manifest matches the display_name
  ) do
    display_name = custom.display_names.sample
    post '/create_custom_kata', display_name:display_name
    assert_equal 302, last_response.status, :last_response_status
    follow_redirect!
    match = last_request.url.match(%r{http://example.org/kata/edit/(.*)})
    assert match, "did not match #{last_request.url}"
    id = match[1]
    assert kata_exists?(id), "kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  # - - - - - - - - - - - - - - - - -

  test 'q31', %w(
  POST /create_custom_group,
  with a valid display_name in the Request body(in json),
  creates a group with an id,
  and whose manifest matches the display_name,
  and puts the id in the Response body (as json)
  ) do
    display_name = custom.display_names.sample
    data = { display_name:display_name }
    post '/create_custom_group', data.to_json, JSON_REQUEST_HEADERS
    assert_equal 200, last_response.status, :last_response_status
    id = json_response['id']
    refute_nil id, :id
    assert group_exists?(id), "group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  # - - - - - - - - - - - - - - - - -

  test 'q32', %w(
  POST /create_custom_kata,
  with a valid display_name in the Request body(in json),
  creates a kata with an id,
  and whose manifest matches the display_name,
  and puts the id in the Response body (as json)
  ) do
    display_name = custom.display_names.sample
    data = { display_name:display_name }
    post '/create_custom_kata', data.to_json, JSON_REQUEST_HEADERS
    assert_equal 200, last_response.status, :last_response_status
    id = json_response['id']
    refute_nil id, :id
    assert kata_exists?(id), "group_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  private

  JSON_REQUEST_HEADERS = {
    'HTTP_ACCEPT' => 'application/json',
    'CONTENT_TYPE' => 'application/json'
  }

end
