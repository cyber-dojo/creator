# frozen_string_literal: true
require_relative 'http_json/service'

class CustomStartPoints

  class Error < RuntimeError
    def initialize(message)
      super
    end
  end

  def initialize(http)
    @http = HttpJson::service(http, 'custom-start-points', 4526, Error)
  end

  def display_names
    @http.get(:names, {})
  end

  def manifest(name)
    @http.get(__method__, { name:name })
  end

end
