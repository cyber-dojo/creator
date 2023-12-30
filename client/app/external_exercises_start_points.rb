require_relative 'http_json_hash/service'

class ExternalExercisesStartPoints

  def initialize(http)
    service = 'exercises-start-points'
    port = ENV['CYBER_DOJO_EXERCISES_START_POINTS_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def names
    @http.get(__method__, {})
  end

end
