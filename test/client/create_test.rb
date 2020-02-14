# frozen_string_literal: true
require_relative 'creator_test_base'

class CreateTest < CreatorTestBase

  def self.id58_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( create_group returns the id of a newly created group ) do
    id = creator.create_group(any_manifest)
    assert group_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - -

  test '703',
  %w( create_kata returns the id of a newly created kata ) do
    id = creator.create_kata(any_manifest)
    assert kata_exists?(id), id
  end

end
