# frozen_string_literal: true
require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.id58_prefix
    :a87
  end

  # - - - - - - - - - - - - - - - - -

  qtest d15: %w( its alive ) do
    assert true?(externals.creator.alive?)
  end

end
