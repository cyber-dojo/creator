# frozen_string_literal: true
require_relative 'creator_test_base'

class ReadyTest < CreatorTestBase

  def self.id58_prefix
    'A86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( its ready ) do
    ready = creator.ready?
    assert ready.is_a?(TrueClass) || ready.is_a?(FalseClass)
    assert ready
  end

  #TODO: not ready when saver service is not ready
  
end
