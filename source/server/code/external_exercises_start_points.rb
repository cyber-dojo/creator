# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalExercisesStartPoints

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'exercises-start-points', 4525)
  end

  def ready?
    @http.get(__method__, {})
  end

  def display_names
    @http.get(:names, {})
  end

  #def manifests
  #  @http.get(:manifests, {})
  #end

  def manifest(display_name)
    @http.get(__method__, { name:display_name })
  end

end