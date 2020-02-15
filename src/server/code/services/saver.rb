# frozen_string_literal: true
require_relative 'json_hash/http/service'

class Saver

  class Error < RuntimeError
    def initialize(message)
      super
    end
  end

  def initialize(http)
    @http = JsonHash::Http::service(http, 'saver', 4537, Error)
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

  def batch(commands)
    @http.post(__method__, { commands:commands })
  end

end
