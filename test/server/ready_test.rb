# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class ReadyTest < CreatorTestBase

  def self.id58_prefix
    'a86'
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( /ready? is true when custom_start_points and saver are ready ) do
    assert true?(creator.ready?)
  end

  # - - - - - - - - - - - - - - - - -

  test '15E',
  %w( /ready? is false when custom_start_points is not ready ) do
    externals.instance_exec { @custom_start_points = STUB_READY_FALSE }
    assert false?(creator.ready?)
  end

  # - - - - - - - - - - - - - - - - -

  test '15F',
  %w( /ready? is false when saver is not ready ) do
    externals.instance_exec { @saver = STUB_READY_FALSE }
    assert false?(creator.ready?)
  end

  private

  STUB_READY_FALSE = OpenStruct.new(:ready? => false)

end
