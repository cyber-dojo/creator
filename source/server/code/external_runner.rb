require_relative 'http_json_hash/service'

class ExternalRunner

  def initialize(http)
    service = 'runner'
    port = ENV['CYBER_DOJO_RUNNER_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def ready?
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - -

  def pull_image(id, image_name)
    @http.post(__method__, {
      id:id,
      image_name:image_name
    })
  end

end
