# frozen_string_literal: true
require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  def self.id58_prefix
    '16F'
  end

  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( group_create_custom([unknown_display_name]) raises exception ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.deprecated_group_create_custom(['xxx'])
    }
  end

  test '45a',
  %w( kata_create_custom(unknown_display_name) raises exception ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.deprecated_kata_create_custom('xxx')
    }
  end

end
