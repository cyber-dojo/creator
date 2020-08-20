# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class LanguageCreateTest < CreatorTestBase

  def self.id58_prefix
    'P42'
  end

  def id58_setup
    @exercise_name = 'Fizz Buzz'
    @language_name = languages_start_points.display_names.sample
  end

  attr_reader :exercise_name, :language_name

  # - - - - - - - - - - - - - - - - -
  # group_create
  # - - - - - - - - - - - - - - - - -

  test 'w9A', %w(
  |GET /group_language_create?exercise_names=X&languages_names[]=Y
  |where X is the name of an exercises-start-point
  |where Y is the name of a languages-start-point
  |redirects to /kata/group/:id page
  |and a group-exercise with :id exists
  ) do
    get '/group_language_create', {
      exercise_name:exercise_name,
      languages_names:[language_name]
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/group/xCSKgZ
    assert %r"http://example.org/kata/group/(?<id>.*)" =~ url, url
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9C', %w(
  |POST /group_create
  |with body containing exercise-name and languages_names
  |returns json payload
  |with {"group_create":"ID"}
  |where a group with ID exists
  ) do
    json_post path='group_create', {
      exercise_name:exercise_name,
      languages_names:[language_name]
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal [path], json_response.keys.sort, :keys
    id = json_response[path] # eg xCSKgZ
    assert group_exists?(id), "id:#{id}:"
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], :exercise
  end

  # - - - - - - - - - - - - - - - - -
  # kata_create
  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |GET /kata_language_create?exercise_name=X&language_name=Y
  |where X is the name of an exercises-start-point
  |where Y is the name of a languages-start-point
  |redirects to /kata/edit/:id page
  |and an individual-exercise with :id exists
  ) do
    get '/kata_language_create', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/edit/H3Nqu2
    assert %r"http://example.org/kata/edit/(?<id>.*)" =~ url, url
    assert kata_exists?(id), "id:#{id}:" # eg H3Nqu2
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9D', %w(
  |POST /kata_create
  |with body containing exercise-name and languages_names
  |returns json payload
  |with {"kata_create":"ID"}
  |where a kata with ID exists
  ) do
    json_post path='kata_create', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal [path], json_response.keys.sort, :keys
    id = json_response[path] # eg H3Nqu2
    assert kata_exists?(id), "id:#{id}:"
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

end
