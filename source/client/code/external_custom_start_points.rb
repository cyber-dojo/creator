# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalCustomStartPoints

  def initialize(http)
    service = 'custom-start-points'
    port = ENV['CYBER_DOJO_CUSTOM_START_POINTS_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def display_names
    @http.get(:names, {})
  end

end
