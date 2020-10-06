# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalAvatars

  def initialize(http)
    name = 'avatars'
    port = ENV['CYBER_DOJO_AVATARS_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, name, port)
  end

  def ready?
    @http.get(__method__, {})
  end

  def names
    @http.get(__method__, {})
  end

end
