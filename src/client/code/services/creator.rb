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

  def alive?
    @http.get(__method__, {})
  end

  def ready?
    @http.get(__method__, {})
  end

  def sha
    @http.get(__method__, {})
  end

  def create_group(manifest)
    @http.post(__method__, {manifest:manifest})
  end

  def create_kata(manifest)
    @http.post(__method__, {manifest:manifest})
  end

end
