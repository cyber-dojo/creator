# frozen_string_literal: true
require_relative 'creator_test_base'

class ReadyTest < CreatorTestBase

  def self.id58_prefix
    'A86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D', 'its ready' do
    assert true?(creator.ready?)
  end

end
