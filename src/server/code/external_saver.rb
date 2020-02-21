# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalSaver

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'saver', 4537)
  end

  def ready?
    @http.get(__method__, {})
  end

  def create(key)
    @http.post(__method__, { key:key })
  end

  def exists?(key)
    @http.get(__method__, { key:key })
  end

  def read(key)
    @http.get(__method__, { key:key })
  end

  def batch(commands)
    @http.post(__method__, { commands:commands })
  end

end
