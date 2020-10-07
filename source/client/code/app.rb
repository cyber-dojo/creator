# frozen_string_literal: true
require_relative 'creator_http_proxy'
require_relative 'app_base'

class App < AppBase

  def initialize(externals)
    super(externals)
    @externals = externals
  end

  get_delegate(CreatorHttpProxy, :alive?)
  get_delegate(CreatorHttpProxy, :ready?)
  get_delegate(CreatorHttpProxy, :sha)

  #def target
  #  Creator.new(@externals)
  #end

  #probe(:alive?) # curl/k8s
  #probe(:ready?) # curl/k8s
  #get_json(:sha) # identity

end
