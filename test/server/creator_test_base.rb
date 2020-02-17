# frozen_string_literal: true
require_relative '../id58_test_base'
require_src 'app'
require_src 'externals'
require_src 'creator'
require_src 'id_pather'
require 'json'

class CreatorTestBase < Id58TestBase
  include Rack::Test::Methods

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def creator
    @creator ||= Creator.new(externals)
  end

  def app
    @app ||= App.new(nil, creator)
  end

  def json_response
    JSON.parse(last_response.body)
  end

  def true?(b)
    assert b.is_a?(TrueClass)
  end

  def false?(b)
    assert b.is_a?(FalseClass)
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

  # - - - - - - - - - - - - - - - -

  def custom
    externals.custom_start_points
  end

  private

  include IdPather

  def saver
    externals.saver
  end

end
