# frozen_string_literal: true
require_relative 'http_json_hash/service'

class ExternalSaver

  def initialize(http)
    @http = HttpJsonHash::service(self.class.name, http, 'saver', 4537)
  end

  def ready?
    @http.get(__method__, {})
  end

  # - - - - - - - - - - - - - - - - - - -

  def create_command(dirname)
    ['create',dirname]
  end

  def exists_command(dirname)
    ['exists?',dirname]
  end

  def write_command(filename, content)
    ['write',filename,content]
  end

  def read_command(filename)
    ['read',filename]
  end

  # - - - - - - - - - - - - - - - - - - -
  # primitives

  def run(command)
    @http.post(__method__, { command:command })
  end

  # - - - - - - - - - - - - - - - - - - -
  # batches

  def batch_assert(commands)
    @http.post(__method__, { commands:commands })
  end

end
