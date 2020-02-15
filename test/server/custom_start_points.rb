# frozen_string_literal: true
require_src 'services/http_json_hash/service'
require_src 'services/http_json_hash/error'

class CustomStartPoints

  def initialize(http)
    @http = HttpJsonHash::service(http, 'custom-start-points', 4526, HttpJsonHash::Error)
  end

  def display_names
    @http.get(:names, {})
  end

  def manifest(display_name)
    @http.get(__method__, { name:display_name })
  end

end
