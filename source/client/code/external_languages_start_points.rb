# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalLanguagesStartPoints

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'languages-start-points', 4524)
  end

  def display_names
    @http.get(:names, {})
  end

end
