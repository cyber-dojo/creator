# frozen_string_literal: true
require_relative '../id58_test_base'
require_src 'externals'

class CreatorTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def creator
    externals.creator
  end

  def externals
    @externals ||= Externals.new
  end

end
