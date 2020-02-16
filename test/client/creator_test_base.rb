# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'id_pather'
require_src 'externals'
require 'json'

class CreatorTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def creator
    externals.creator
  end

  # - - - - - - - - - - - - - - - - - - -

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

  # - - - - - - - - - - - - - - - - - - -

  def any_display_name
    custom.display_names.shuffle[0]
  end

  def custom
    externals.custom
  end

  # - - - - - - - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

  # - - - - - - - - - - - - - - - - - - -

  def externals
    @externals ||= Externals.new
  end

end
