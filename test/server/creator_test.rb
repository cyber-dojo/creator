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
    assert_302_response
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
    assert_302_response
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
    assert_200_response
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
    assert_200_response
    assert_kata_exists(id_from_json_response, data[:display_name])
  end

  private

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
