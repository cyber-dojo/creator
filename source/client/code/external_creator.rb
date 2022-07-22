require_relative 'http_json_hash/service'

class ExternalCreator

  def initialize(http)
    name = ENV['CYBER_DOJO_CREATOR_HOSTNAME']
    if name.nil?
      name = 'creator'
    end
    port = ENV['CYBER_DOJO_CREATOR_PORT'].to_i
    @http = HttpJsonHash::service(self.class.name, http, name, port)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def alive?
    @http.get(__method__, {})
  end

  def ready?
    @http.get(__method__, {})
  end

  def sha
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_group_create_custom(display_name)
    @http.post(__method__, {display_name:display_name})
  end

  def deprecated_kata_create_custom(display_name)
    @http.post(__method__, {display_name:display_name})
  end

end
