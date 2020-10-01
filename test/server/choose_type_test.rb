# frozen_string_literal: true
require_relative 'creator_test_base'

class ChooseTypeTest < CreatorTestBase

  def self.id58_prefix
    'X73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/choose_type
  |200
  ) do
    get '/choose_type'
    assert status?(200), status
  end

end
