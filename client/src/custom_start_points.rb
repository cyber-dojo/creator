# frozen_string_literal: true
require_relative 'http_json/requester'
require_relative 'http_json/responder'

class CustomStartPoints

  def initialize(http)
    requester = HttpJson::Requester.new(http, 'custom-start-points', 4526)
    @http = HttpJson::Responder.new(requester, RuntimeError)
  end

  def manifest(name)
    @http.get(__method__, { name:name })
  end

end
