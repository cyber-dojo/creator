require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  # - - - - - - - - - - - - - - - - -

  qtest Fy3e45:
  %w(group_create_custom([unknown_display_name]) raises exception) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.deprecated_group_create_custom(['xxx'])
    end
  end

  qtest Fy3a45:
  %w(kata_create_custom(unknown_display_name) raises exception) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.deprecated_kata_create_custom('xxx')
    end
  end
end
