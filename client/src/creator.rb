# frozen_string_literal: true
require_relative 'http_json/requester'
require_relative 'http_json/responder'

class Creator

  class Error < RuntimeError
    def initialize(message)
      super
    end
  end

  def initialize(http)
    requester = HttpJson::Requester.new(http, 'creator-server', 4523)
    @http = HttpJson::Responder.new(requester, Error, { raw:true })
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

=begin
  def run_cyber_dojo_sh(image_name, id, files, max_seconds)
    @http.get(__method__, {
      image_name:image_name,
      id:id,
      files:files,
      max_seconds:max_seconds
    })
  end
=end

end
