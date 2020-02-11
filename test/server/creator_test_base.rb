# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'custom_start_points'
require_src 'externals'
require_src 'creator'
require_src 'id_pather'

class CreatorTestBase < Id58TestBase

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

  def any_manifest
    custom.manifest(any_display_name)
  end

  def any_display_name
    custom.display_names.shuffle[0]
  end

  def custom
    CustomStartPoints.new(externals.http)
  end

  private

  include IdPather # group_id_path, kata_id_path

end
