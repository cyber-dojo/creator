# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class CreateKataTest < CreatorTestBase

  def self.id58_prefix
    'p43'
  end

  def id58_setup
    @exercise_name = exercises_start_points.display_names.sample
    @display_name = custom_start_points.display_names.sample
    @language_name = languages_start_points.display_names.sample
  end

  attr_reader :exercise_name, :display_name, :language_name

  # - - - - - - - - - - - - - - - - -

  test 'w9A', %w(
  |GET /create_kata_exercise
  |with [exercise_name,language_name] URL params
  |redirects to /kata/edit/ID page
  |and a kata-exercise with ID exists
  ) do
    get '/create_kata_exercise', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/edit/xCSKgZ
    assert %r"http://example.org/kata/edit/(?<id>.*)" =~ url, url
    assert kata_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = kata_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |GET /create_kata_exercise
  |with [display_name] URL params
  |redirects to /kata/edit/ID page
  |and a kata-exercise with ID exists
  ) do
    get '/create_kata_exercise', {
      display_name:display_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/kata/edit/xCSKgZ
    assert %r"http://example.org/kata/edit/(?<id>.*)" =~ url, url
    assert kata_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
  end

end
