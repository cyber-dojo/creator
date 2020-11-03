# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class BuildManifestTest < CreatorTestBase

  def self.id58_prefix
    :s92
  end

  # - - - - - - - - - - - - - - - - -

  qtest w9A: %w(
  |GET /build_manifest
  |with [exercise_name,language_name] URL params
  |generates json manifest
  ) do
    exercise_name = any_exercises_start_points_display_name
    language_name = any_languages_start_points_display_name
    args = {
      exercise_name:exercise_name,
      language_name:language_name
    }
    assert_get_200_json('build_manifest', args) do |manifest|
      assert_equal language_name, manifest['display_name'], manifest
      assert_equal exercise_name, manifest['exercise'], manifest
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest w9B: %w(
  |GET /build_custom_manifest
  |with [display_name] URL param
  |generates json manifest
  ) do
    display_name = any_custom_start_points_display_name
    args = { display_name:display_name }
    assert_get_200_json('build_custom_manifest', args) do |manifest|
      assert_equal display_name, manifest['display_name'], manifest
    end
  end

end
