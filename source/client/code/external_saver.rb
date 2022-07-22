require_relative 'http_json_hash/service'

class ExternalSaver

  def initialize(http)
    service = ENV['CYBER_DOJO_SAVER_HOSTNAME']
    if service.nil?
      service = 'saver'
    end
    port = ENV['CYBER_DOJO_SAVER_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def group_exists?(id)
    @http.get(__method__, { id:id })
  end

  def group_manifest(id)
    @http.get(__method__, { id:id })
  end

  def kata_exists?(id)
    @http.get(__method__, { id:id })
  end

  def kata_manifest(id)
    @http.get(__method__, { id:id })
  end

end
