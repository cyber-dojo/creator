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

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

end
