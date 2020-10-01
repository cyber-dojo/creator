# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class CreateGroupTest < CreatorTestBase

  def self.id58_prefix
    'p42'
  end

  def id58_setup
    @exercise_name = exercises_start_points.display_names.sample
    @display_name = custom_start_points.display_names.sample
    @language_name = languages_start_points.display_names.sample
  end

  attr_reader :exercise_name, :display_name, :language_name

  # - - - - - - - - - - - - - - - - -

  test 'w9A', %w(
  |GET /create_group_exercise
  |with [exercise_name,language_name] URL params
  |redirects to /home/enter?id=ID page
  |and a group-exercise with ID exists
  ) do
    get '/create_group_exercise', {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/home/enter?id=xCSKgZ
    assert %r"http://example.org/home/enter\?id=(?<id>.*)" =~ url, url
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |GET /create_group_exercise
  |with [display_name] URL params
  |redirects to /home/enter?id=ID page
  |and a group-exercise with ID exists
  ) do
    get '/create_group_exercise', {
      display_name:display_name
    }
    assert status?(302), status
    follow_redirect!
    assert html_content?, content_type
    url = last_request.url # eg http://example.org/home/enter?id=xCSKgZ
    assert %r"http://example.org/home/enter\?id=(?<id>.*)" =~ url, url
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
  end

end
