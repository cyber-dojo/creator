# frozen_string_literal: true
require_relative 'creator_test_base'

class CreateTest < CreatorTestBase

  def self.id58_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -
  # old API (deprecated)
  # - - - - - - - - - - - - - - - - -

  test '802',
  %w( deprecated_create_custom_group returns the id of a newly created group ) do
    display_name = any_custom_start_point_display_name
    id = creator.deprecated_create_custom_group(display_name)
    assert group_exists?(id), id
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

  # - - - - - - - - - - - - - - - - -

  test '803',
  %w( deprecated_create_custom_kata returns the id of a newly created kata ) do
    display_name = any_custom_start_point_display_name
    id = creator.deprecated_create_custom_kata(display_name)
    assert kata_exists?(id), id
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

  # - - - - - - - - - - - - - - - - -
  # new API
  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( create_custom_group returns the id of a newly created group ) do
    display_name = any_custom_start_point_display_name
    id = creator.create_custom_group([display_name])
    assert group_exists?(id), id
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

  # - - - - - - - - - - - - - - - - -

  test '703',
  %w( create_custom_kata returns the id of a newly created kata ) do
    display_name = any_custom_start_point_display_name
    id = creator.create_custom_kata(display_name)
    assert kata_exists?(id), id
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

end
