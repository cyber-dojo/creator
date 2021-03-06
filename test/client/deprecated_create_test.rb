# frozen_string_literal: true
require_relative 'creator_test_base'

class DeprecatedCreateTest < CreatorTestBase

  def self.id58_prefix
    :f26F
  end

  def id58_setup
    @display_name = any_custom_start_points_display_name
  end

  attr_reader :display_name

  # - - - - - - - - - - - - - - - - -

  qtest K80:
  %w( deprecated_group_create_custom returns the id of a newly created group ) do
    id = creator.deprecated_group_create_custom(display_name)
    assert group_exists?(id), id
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

  # - - - - - - - - - - - - - - - - -

  qtest K81:
  %w( deprecated_kata_create_custom returns the id of a newly created kata ) do
    id = creator.deprecated_kata_create_custom(display_name)
    assert kata_exists?(id), id
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name']
  end

end
