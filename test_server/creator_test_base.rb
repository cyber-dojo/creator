require_relative 'hex_mini_test'
require_relative '../externals'
require_relative '../creator'
require_relative '../id_pather'

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

  def group_exists?(id)
    saver.exists?(group_id_path(id))
  end

  def kata_exists?(id)
    saver.exists?(kata_id_path(id))
  end

  def manifest
    custom.manifest(display_name)
  end

  def display_name
    custom.display_names.shuffle[0]
  end

  def custom
    CustomStartPoints.new(externals.http)
  end

  private

  include IdPather # group_id_path, kata_id_path

end
