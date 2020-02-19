# frozen_string_literal: true
require_relative 'json_app_base'
require_relative 'creator'

class App < JsonAppBase

  def initialize(app=nil, creator=nil)
    super(app)
    @creator = creator
  end

  # identity
  get_json(:sha)
  # curl/k8s probing
  get_json(:alive?)
  get_json(:ready?)
  # main routes
  post_json(:create_custom_group)
  post_json(:create_custom_kata)

  private

  def target
    # In production, @creator is nil, each request => Creator.new
    # In testing, @creator is non-nil to allow stubbing
    @creator || Creator.new
  end

end
