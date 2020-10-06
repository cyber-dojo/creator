# frozen_string_literal: true
require_relative 'creator_test_base'
require_source 'external_http'
require 'json'

class CustomCreateTest < CreatorTestBase

  def self.id58_prefix
    'v42'
  end

  def id58_setup
    @display_name = custom_start_points.display_names.sample
  end

  attr_reader :display_name

  # - - - - - - - - - - - - - - - - -
  # 302
  # - - - - - - - - - - - - - - - - -

  test 'w9A', %w(
  |GET /group_custom_create?display_names[]=...
  |redirects to /kata/group/:id page
  |and a group with :id exists
  ) do
    get '/group_custom_create', display_name:display_name
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/group/xCSKgZ
    assert %r"http://example.org/kata/group/(?<id>.*)" =~ url, url
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
    refute manifest.has_key?('exercise'), :exercise
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |GET /kata_custom_create?display_name=...
  |redirects to /kata/edit/:id page
  |and a kata with :id exists
  ) do
    get '/kata_custom_create', display_name:display_name
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/edit/H3Nqu2
    assert %r"http://example.org/kata/edit/(?<id>.*)" =~ url, url
    assert kata_exists?(id), "id:#{id}:" # eg H3Nqu2
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
    refute manifest.has_key?('exercise'), :exercise
  end

  # - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - -

  test 'Je4', %w(
  |GET/kata_custom_create with unknown display_name
  |is 500 error
  ) do
    stdout,stderr = capture_io {
      get '/kata_custom_create', display_name:'unknown'
    }
    verify_exception_info_on(stdout, 'http_service')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'Bq7', %w(
  |GET/group_custom_create with extra parameter
  |is 500 error
  ) do
    stdout,stderr = capture_io {
      get '/kata_custom_create', {
        display_name:display_name,
        extra:'wibble'
      }
    }
    verify_exception_info_on(stdout, 'message')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'xW9', %w(
  |GET/group_custom_create with non-JSON in request body
  |is 500 error
  ) do
    stdout,stderr = capture_io {
      get '/kata_custom_create', 'non-JSON', { 'CONTENT_TYPE' => 'application/json' }
    }
    verify_exception_info_on(stdout, 'message')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end

  # - - - - - - - - - - - - - - - - -

  test 'xW8', %w(
  |GET/group_custom_create with non-JSON-Hash in request body
  |is 500 error
  ) do
    stdout,stderr = capture_io {
      get '/kata_custom_create', '42', { 'CONTENT_TYPE' => 'application/json' }
    }
    verify_exception_info_on(stdout, 'message')
    assert_equal '', stderr, :stderr_is_empty
    assert status?(500), status
  end


end
