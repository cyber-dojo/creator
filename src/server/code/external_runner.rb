# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalRunner

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'runner', 4597)
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
