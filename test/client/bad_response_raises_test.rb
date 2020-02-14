# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class BadResponseRaisesTest < CreatorTestBase

  def self.id58_prefix
    '20F'
  end

  # - - - - - - - - - - - - - - - - -

  test '34a',
  %w( http body not JSON raises ) do
    externals.instance_exec {
      @http = HttpAdapterStub.new('{"sd":}')
    }
    error = assert_raises(Creator::Error) {
      creator.alive?
    }
    expected = 'http response.body is not JSON:{"sd":}'
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test '34b',
  %w( http body not JSON Hash raises ) do
    externals.instance_exec {
      @http = HttpAdapterStub.new('42')
    }
    error = assert_raises(Creator::Error) {
      creator.alive?
    }
    expected = 'http response.body is not JSON Hash:42'
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test '34c',
  %w( http body JSON without key for method name raises ) do
    externals.instance_exec {
      @http = HttpAdapterStub.new('{}')
    }
    error = assert_raises(Creator::Error) {
      creator.alive?
    }
    expected = "http response.body has no key for 'alive?':{}"
    assert_equal expected, error.message
  end

  private

  class HttpAdapterStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      self
    end
    attr_reader :body
  end

end
