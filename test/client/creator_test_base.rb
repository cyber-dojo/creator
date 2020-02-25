# frozen_string_literal: true
require_relative '../id58_test_base'
require_relative 'id_pather'
require_src 'creator'
require_src 'externals'
require 'json'

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

  # - - - - - - - - - - - - - - - - - - -

  def creator_http_stub(body)
    externals.instance_exec { @creator_http = HttpAdapterStub.new(body) }
  end

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def post(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
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

  def any_custom_start_point_display_name
    custom_start_points.display_names.sample
  end

  def custom_start_points
    externals.custom_start_points
  end

  # - - - - - - - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

end
