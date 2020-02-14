# frozen_string_literal: true
require_relative 'http_json/service'

class Saver

  class Error < RuntimeError
    def initialize(message)
      super
    end
  end

  def initialize(http)
    @http = HttpJson::service(http, 'saver', 4537, Error)
  end

  def exists?(key)
    @http.get(__method__, { key:key })
  end

end
