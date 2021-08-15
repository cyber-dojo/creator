require_relative 'http_json_hash/service'

class ExternalSaver

  def initialize(http)
    service = 'saver'
    port = ENV['CYBER_DOJO_SAVER_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, service, port)
  end

  def ready?
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_name)
    @http.post(__method__, {
      version: CURRENT_VERSION,
      display_name: display_name
    })
  end

  def group_create(ltf_name, exercise_name)
    @http.post(__method__, {
      version: CURRENT_VERSION,
      ltf_name: ltf_name,
      exercise_name: exercise_name
    })
  end

  def group_exists?(id)
    @http.get(__method__, { id:id })
  end

  def group_manifest(id)
    @http.get(__method__, { id:id })
  end

  def group_join(id)
    @http.post(__method__, { id:id })
  end

  def group_joined(id)
    @http.get(__method__, { id:id })
  end

  # - - - - - - - - - - - - - - - - - - -

  def kata_create_custom(display_name)
    @http.post(__method__, {
      version: CURRENT_VERSION,
      display_name: display_name
    })
  end

  def kata_create(ltf_name, exercise_name)
    @http.post(__method__, {
      version: CURRENT_VERSION,
      ltf_name: ltf_name,
      exercise_name: exercise_name
    })
  end

  def kata_exists?(id)
    @http.get(__method__, { id:id })
  end

  def kata_manifest(id)
    @http.get(__method__, { id:id })
  end

  private

  CURRENT_VERSION = 2

end
