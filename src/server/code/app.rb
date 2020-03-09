# frozen_string_literal: true
require_relative 'creator'
require_relative 'app_base'

class App < AppBase

  def initialize(externals)
    super()
    @externals = externals
  end

  def target
    Creator.new(@externals)
  end

  get_probe(:alive?) # curl/k8s
  get_probe(:ready?) # curl/k8s
  get_probe(:sha)    # identity

  post_json(:group_create_custom)
  post_json(:kata_create_custom)

  deprecated_post_json(:deprecated_group_create_custom)
  deprecated_post_json(:deprecated_kata_create_custom)

end
