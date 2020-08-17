# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalPuller

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'puller', 5017)
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
