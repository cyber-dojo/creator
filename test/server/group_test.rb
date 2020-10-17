# frozen_string_literal: true
require_relative 'creator_test_base'

class GroupTest < CreatorTestBase

  def self.id58_prefix
    :q8d
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/group is 200
  ) do
    get '/group'
    assert status?(200), status
  end

end
