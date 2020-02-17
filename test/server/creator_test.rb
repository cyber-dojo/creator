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

end
