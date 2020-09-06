# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalModel

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'model', 4528)
  end

  def ready?
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - -

  def group_exists?(id)
    @http.get(__method__, { id:id })
  end

  def group_create(manifests, options)
    @http.post(__method__, {
      manifests:manifests,
      options:options
    })
  end

  def group_manifest(id)
    @http.get(__method__, { id:id })
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_exists?(id)
    @http.get(__method__, { id:id })
  end

  def kata_create(manifest, options)
    @http.post(__method__, {
      manifest:manifest,
      options:options
    })
  end

  def kata_manifest(id)
    @http.get(__method__, { id:id })
  end

end
