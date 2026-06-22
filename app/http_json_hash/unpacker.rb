require_relative 'service_error'
require 'json'

module HttpJsonHash
  class Unpacker
    def initialize(name, requester)
      @name = name
      @requester = requester
    end

    attr_reader :name, :requester

    def get(path, args)
      response = @requester.get(path, args)
      unpacked(response, path.to_s, args)
    end

    def post(path, args)
      response = @requester.post(path, args)
      unpacked(response, path.to_s, args)
    end

    private

    def unpacked(response, path, args)
      body = response.body
      json = JSON.parse!(body)
      service_error(response, path, args, 'body has embedded exception') if json.is_a?(Hash) && json.key?('exception')
      if json.is_a?(Hash) && json.key?(path)
        json[path]
      else
        json
      end
    rescue JSON::ParserError
      service_error(response, path, args, 'body is not JSON')
    end

    def service_error(response, path, args, message)
      raise ::HttpJsonHash::ServiceError.new(path, args, @name, response.body, response.code, message)
    end
  end
end
