# frozen_string_literal: true
require_relative '../id58_test_base'
require_src 'externals'
require_src 'creator'
require_src 'id_pather'
require 'json'

class CreatorTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def creator
    Creator.new(externals)
  end

  # - - - - - - - - - - - - - - - -

  def group_exists?(id)
    saver.exists?(group_id_path(id))
  end

  def group_manifest(id)
    JSON::parse!(saver.read("#{group_id_path(id)}/manifest.json"))
  end

  def kata_exists?(id)
    saver.exists?(kata_id_path(id))
  end

  def kata_manifest(id)
    JSON::parse!(saver.read("#{kata_id_path(id)}/manifest.json"))
  end

  def saver
    externals.saver
  end

  include IdPather

  # - - - - - - - - - - - - - - - -

  def any(names)
    names.shuffle[0]
  end

  def custom
    externals.custom_start_points
  end

  # - - - - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

  # - - - - - - - - - - - - - - - -

  def externals
    @externals ||= Externals.new
  end

end
