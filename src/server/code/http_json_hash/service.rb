# frozen_string_literal: true
require_relative 'requester'
require_relative 'responder'

module HttpJsonHash

  def self.service(name, http, hostname, port)
    requester = Requester.new(http, hostname, port)
    Responder.new(name, requester)
  end

end
