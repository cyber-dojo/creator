require_relative 'creator_test_base'
require 'ostruct'

class BadResponseRaisesTest < CreatorTestBase

  # - - - - - - - - - - - - - - - - -

  qtest f2Ga34:
  %w[http body not JSON raises] do
    creator_http_stub('{42:"sd"}')
    error = assert_raises(HttpJsonHash::ServiceError) { externals.creator.ready? }
    expected = 'body is not JSON'
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  qtest f2Gb34:
  %w[http body not JSON Hash raises] do
    creator_http_stub('42')
    error = assert_raises(HttpJsonHash::ServiceError) { externals.creator.ready? }
    expected = 'body is not JSON Hash'
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  qtest f2Gc34:
  %w[http body JSON without key for method name raises] do
    creator_http_stub('{}')
    error = assert_raises(HttpJsonHash::ServiceError) { externals.creator.ready? }
    expected = 'body is missing :path key'
    assert_equal expected, error.message
  end

  private

  def creator_http_stub(body)
    externals.instance_exec { @creator_http = HttpAdapterStub.new(body) }
  end

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
