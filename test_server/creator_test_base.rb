require_relative 'hex_mini_test'
require_relative '../externals'
require_relative '../creator'

class CreatorTestBase < HexMiniTest

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def creator
    Creator.new(externals)
  end

  def saver
    externals.saver
  end

end
