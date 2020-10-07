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
  |POST /create.json
  |with [type=group,exercise_name,language_name] URL params
  |generates json route /creator/enter?id=ID page
  |and a group-exercise with ID exists
  ) do
    args = {
      type:'group',
      exercise_name:exercise_name,
      language_name:language_name
    }
    json_post '/create.json', args
    route = json_response['route'] # eg "/creator/enter?id=xCSKgZ"
    assert %r"/creator/enter\?id=(?<id>.*)" =~ route, route
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9B', %w(
  |POST /create.json
  |with [type=group,language_name] URL params
  |generates json route /creator/enter?id=ID page
  |and a group-exercise with ID exists
  ) do
    args = {
      type:'group',
      language_name:language_name
    }
    json_post '/create.json', args
    route = json_response['route'] # eg "/creator/enter?id=xCSKgZ"
    assert %r"/creator/enter\?id=(?<id>.*)" =~ route, route
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal language_name, manifest['display_name'], manifest
    refute manifest.has_key?('exercise'), :skipped_exercise
  end

  # - - - - - - - - - - - - - - - - -

  test 'w9C', %w(
  |POST /create.json
  |with [type=group,display_name] URL params
  |generates json route /creator/enter?id=ID page
  |and a group-exercise with ID exists
  ) do
    args = {
      type:'group',
      display_name:display_name
    }
    json_post '/create.json', args
    route = json_response['route'] # eg "/creator/enter?id=xCSKgZ"
    assert %r"/creator/enter\?id=(?<id>.*)" =~ route, route
    assert group_exists?(id), "id:#{id}:" # eg xCSKgZ
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest
    refute manifest.has_key?('exercise'), :skipped_exercise    
  end

end
