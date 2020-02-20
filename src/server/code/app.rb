# frozen_string_literal: true
require_relative 'json_app_base'

class App < JsonAppBase

  def initialize(target)
    super(target)
  end

  # identity
  get_json(:sha)
  # main routes
  post_json(:create_custom_group)
  post_json(:create_custom_kata)

end
