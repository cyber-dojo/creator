# frozen_string_literal: true
require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.id58_prefix
    'a87'
  end

  # - - - - - - - - - - - - - - - - -

  test '15d',
  %w( its alive ) do
    alive = creator.alive?
    assert alive.is_a?(TrueClass) || alive.is_a?(FalseClass)
    assert alive
  end

end
