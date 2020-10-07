# frozen_string_literal: true
require_relative 'creator_test_base'

class ReadyTest < CreatorTestBase

  def self.id58_prefix
    :A86
  end

  # - - - - - - - - - - - - - - - - -

  qtest D15: %w( its ready ) do
    assert true?(creator.ready?)
  end

end
