# frozen_string_literal: true
require_relative 'creator'
require_relative 'json_app_base'

class App < JsonAppBase

  def initialize(externals)
    super()
    @externals = externals
  end

  def target
    Creator.new(@externals)
  end

  post_json(:create_custom_group)
  post_json(:create_custom_kata)

end
