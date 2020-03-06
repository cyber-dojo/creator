# frozen_string_literal: true
require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  def self.id58_prefix
    '16F'
  end

  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( group_create_custom(manifest=nil) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.group_create_custom(nil)
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45a',
  %w( custom_start_points.manifest(name='unknown') raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      custom_start_points.manifest('unknown-name')
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45b',
  %w( saver.exists?(key=nil) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      saver.exists?(nil)
    }
  end

end
