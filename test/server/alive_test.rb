# frozen_string_literal: true
require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.id58_prefix
    'a87'
  end

  # - - - - - - - - - - - - - - - - -

  test '15d',
  %w( /alive? is true ) do
    assert true?(creator.alive?)
  end

end
