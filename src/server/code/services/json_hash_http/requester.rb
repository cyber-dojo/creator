# frozen_string_literal: true
require_relative '../../json_hash'
require 'uri'

module JsonHashHttp

  class Requester

    class Error < RuntimeError
      def initialize(message)
        super
      end
    end

    def initialize(http, hostname, port)
      @http = http
      @hostname = hostname
      @port = port
    end

    def get(path, args)
      request(path, args) do |uri|
        @http.get(uri)
      end
    end

    def post(path, args)
      request(path, args) do |uri|
        @http.post(uri)
      end
    end

    private

    def request(path, args)
      uri = URI.parse("http://#{@hostname}:#{@port}/#{path}")
      req = yield uri
      req.content_type = 'application/json'
      req.body = JsonHash::fast(args)
      @http.start(@hostname, @port, req)
    end

  end

end