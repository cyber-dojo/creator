# frozen_string_literal: true
require 'json'

module JsonHash
  module Http
    class Responder

      def initialize(requester, exception_class)
        @requester = requester
        @exception_class = exception_class
      end

      # - - - - - - - - - - - - - - - - - - - - -

      def get(path, args)
        response = @requester.get(path, args)
        unpacked(response.body, path.to_s)
      rescue => error
        fail @exception_class, error.message
      end

      # - - - - - - - - - - - - - - - - - - - - -

      def post(path, args)
        response = @requester.post(path, args)
        unpacked(response.body, path.to_s)
      rescue => error
        fail @exception_class, error.message
      end

      private

      def unpacked(body, path)
        json = json_parse(body)
        unless json.instance_of?(Hash)
          fail error_msg(body, 'not JSON Hash')
        end
        if json.has_key?('exception')
          #TODO: Can this simply return body?
          fail JSON.pretty_generate(json['exception'])
        end
        unless json.has_key?(path)
          fail error_msg(body, "no key for '#{path}'")
        end
        json[path]
      end

      # - - - - - - - - - - - - - - - - - - - - -

      def json_parse(body)
        JSON.parse!(body)
      rescue JSON::ParserError
        fail error_msg(body, 'not JSON')
      end

      # - - - - - - - - - - - - - - - - - - - - -

      def error_msg(body, text)
        "#{text}:#{body}"
      end

    end
  end
end
