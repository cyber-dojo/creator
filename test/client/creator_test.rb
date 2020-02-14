# frozen_string_literal: true
require_relative 'creator_test_base'

class CreatorTest < CreatorTestBase

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

  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( create_group with a null manifest raises ) do
    assert_raises(Creator::Error) {
      creator.create_group(nil)
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45a',
  %w( custom.manifest(unknown_name) raises ) do
    assert_raises(CustomStartPoints::Error) {
      custom.manifest('unknown-name')
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45b',
  %w( saver.exists?(nil) raises ) do
    assert_raises(Saver::Error) {
      saver.exists?(nil)
    }
  end

end
