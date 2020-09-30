# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalCustomStartPoints

  def initialize(http)
    name = 'custom-start-points'
    port = ENV['CYBER_DOJO_CUSTOM_START_POINTS_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, name, port)
  end

  def ready?
    @http.get(__method__, {})
  end

  def display_names
    @http.get(:names, {})
  end

  def manifests
    @http.get(:manifests, {})
  end

  def manifest(display_name)
    @http.get(__method__, { name:display_name })
  end

end
