# frozen_string_literal: true
require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  def self.id58_prefix
    '16F'
  end

  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( create_group(manifest=nil) raises ) do
    assert_raises(Creator::Error) {
      creator.create_group(nil)
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45a',
  %w( custom.manifest(name='unknown') raises ) do
    assert_raises(CustomStartPoints::Error) {
      custom.manifest('unknown-name')
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45b',
  %w( saver.exists?(key=nil) raises ) do
    assert_raises(Saver::Error) {
      saver.exists?(nil)
    }
  end

end
