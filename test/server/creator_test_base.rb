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

  # - - - - - - - - - - - - - - - -

  def assert_group_exists(id, display_name)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def assert_kata_exists(id, display_name)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

  def assert_302_response
    assert_equal 302, last_response.status, :last_response_status
  end

  def assert_200_response
    assert_equal 200, last_response.status, :last_response_status
  end

  def json_response
    JSON.parse(last_response.body)
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

  def any_custom_display_name
    custom.display_names.sample
  end

  private

  include IdPather

  def saver
    externals.saver
  end

end
