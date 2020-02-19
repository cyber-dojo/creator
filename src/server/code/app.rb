# frozen_string_literal: true
require_relative 'app_base'
require_relative 'creator'

class App < AppBase

  # TODO: {"exception":...}
  # TODO: let exception from service (eg saver) propoagate? or wrap?

  # ctor
  def initialize(app=nil, creator=nil)
    super(app)
    @creator = creator
  end

  # identity
  json_get(:sha)

  # k8s/curl probing
  json_get(:alive?)
  json_get(:ready?)

  # main routes
  json_post(:create_custom_group)
  json_post(:create_custom_kata)

  private

  def target
    # In production, @creator is nil, each request => Creator.new
    # In testing, @creator is non-nil to allow stubbing
    @creator || Creator.new
  end

end
