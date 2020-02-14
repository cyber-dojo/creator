# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class ReadyTest < CreatorTestBase

  def self.id58_prefix
    'A86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( its ready when saver is ready ) do
    assert true?(creator.ready?)
  end

  # - - - - - - - - - - - - - - - - -

  test '15E',
  %w( its not ready when saver is not ready ) do
    externals.instance_exec {
      @saver = OpenStruct.new(:ready? => false)
    }
    assert false?(creator.ready?)
  end

end
