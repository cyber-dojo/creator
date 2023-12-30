require_relative 'http_json_hash/service'

class ExternalLanguagesStartPoints

  def initialize(http)
    service = 'languages-start-points'
    port = ENV['CYBER_DOJO_LANGUAGES_START_POINTS_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def names
    @http.get(__method__, {})
  end

end
