# frozen_string_literal: true
require_relative 'http_json/service'

class Creator

  class Error < RuntimeError
    def initialize(message)
      super
    end
  end

  def initialize(http)
    @http = HttpJson::service(http, 'creator-server', 4523, Error)
  end

  def ready?
    @http.get(__method__, {})
  end

end
