require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  def self.id58_prefix
    :Fy3
  end

  # - - - - - - - - - - - - - - - - -

  qtest e45:
  %w( group_create_custom([unknown_display_name]) raises exception ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.deprecated_group_create_custom(['xxx'])
    }
  end

  qtest a45:
  %w( kata_create_custom(unknown_display_name) raises exception ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.deprecated_kata_create_custom('xxx')
    }
  end

end
