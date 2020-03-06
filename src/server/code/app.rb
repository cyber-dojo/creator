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

  deprecated_post_json(:deprecated_create_custom_group)
  deprecated_post_json(:deprecated_create_custom_kata)

  post_json(:create_custom_group)
  post_json(:create_custom_kata)

end
