# frozen_string_literal: true
require_relative 'creator_test_base'

class HomeTest < CreatorTestBase

  def self.id58_prefix
    :Ws9
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/home is 200
  ) do
    get '/home'
    assert status?(200), status
  end

end
