require_relative 'hex_mini_test'
require_relative '../externals'
require_relative '../creator'

class CreatorTestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def creator
    @creator ||= Creator.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

end
