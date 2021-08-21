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

  def names
    @http.get(__method__, {})
  end

  def manifests
    @http.get(__method__, {})
  end

  def manifest(name)
    @http.get(__method__, { name:name})
  end

end
