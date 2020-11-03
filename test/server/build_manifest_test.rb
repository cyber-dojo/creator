# frozen_string_literal: true
require_relative 'creator_test_base'
require 'cgi'
require 'json'

class BuildManifestTest < CreatorTestBase

  def self.id58_prefix
    :s92
  end

  # - - - - - - - - - - - - - - - - -

  qtest w9A: %w(
  |GET /build_manifest.json
  |with [exercise_name,language_name] URL params
  |generates json manifest
  ) do
    exercise_name = exercises_start_points.display_names.sample
    language_name = languages_start_points.display_names.sample
    args = "exercise_name=#{CGI::escape(exercise_name)}"
    args += '&'
    args += "language_name=#{CGI::escape(language_name)}"
    get "/build_manifest?#{args}"
    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    manifest = JSON.parse(last_response.body)
    assert_equal language_name, manifest['display_name'], manifest
    assert_equal exercise_name, manifest['exercise'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  qtest w9B: %w(
  |GET /build_custom_manifest.json
  |with [display_name] URL param
  |generates json manifest
  ) do
    display_name = custom_start_points.display_names.sample
    args = "display_name=#{CGI::escape(display_name)}"
    get "/build_custom_manifest?#{args}"
    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    manifest = JSON.parse(last_response.body)
    assert_equal display_name, manifest['display_name'], manifest
  end

end
