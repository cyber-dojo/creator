# frozen_string_literal: true

require_relative '../services/http_json/service'
require_relative '../services/http_json/error'

class CustomStartPoints

  class Error < HttpJson::Error
    def initialize(message)
      # :nocov:
      super
      # :nocov:
    end
  end

  def initialize(http)
    @http = HttpJson::service(http, 'custom-start-points', 4526, Error)
  end

  def display_names
    @http.get(:names, {})
  end

  def manifest(display_name)
    @http.get(__method__, { name:display_name })
  end

end
