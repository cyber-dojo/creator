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

  probe(:alive?) # curl/k8s
  probe(:ready?) # curl/k8s
  get_json(:sha) # identity

end
