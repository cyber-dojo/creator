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

  SUCCESS = 200
  TEMPORARY_REDIRECT = 302

  def assert_status(expected)
    assert_equal expected, last_response.status, :last_response_status
  end

  def json_response
    JSON.parse(last_response.body)
  end

  # - - - - - - - - - - - - - - - -

  def group_exists?(id)
    saver.exists?(group_id_path(id))
  end

  def kata_exists?(id)
    saver.exists?(kata_id_path(id))
  end

  private

  include IdPather

  def custom
    externals.custom_start_points
  end

  def saver
    externals.saver
  end

end
