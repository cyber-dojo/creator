require_relative 'creator_test_base'
require_relative '../json_adapter'
require 'net/http'
require 'ostruct'

class DependentServiceTest < CreatorTestBase

  def self.hex_prefix
    '078'
  end

  class HttpResponseBodyStub
    def initialize(body)
      @body = body
    end
    def get(uri)
      Net::HTTP::Get.new(uri)
    end
    def post(uri)
      Net::HTTP::Post.new(uri)
    end
    def start(_hostname, _port, _req)
      OpenStruct.new(body:@body)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E30', %w(
  when dependent service POST response body is not JSON Hash
  then dependent::Error is raised ) do
    manifest = any_manifest
    externals.instance_exec {
      @http = HttpResponseBodyStub.new('x')
    }
    error = assert_raises(Saver::Error) {
      creator.create_group(manifest)
    } 
    assert_equal 'http response.body is not JSON:x', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E31', %w(
  when dependent service GET response body is not JSON
  then dependent::Error is raised ) do
    externals.instance_exec {
      @http = HttpResponseBodyStub.new('x')
    }
    error = assert_raises(Saver::Error) {
      creator.ready?
    }
    assert_equal 'http response.body is not JSON:x', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E32', %w(
  when dependent service response body is not JSON Hash
  then dependent::Error is raised ) do
    externals.instance_exec {
      @http = HttpResponseBodyStub.new('[]')
    }
    error = assert_raises(Saver::Error) {
      creator.ready?
    }
    assert_equal 'http response.body is not JSON Hash:[]', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E33', %w(
  when dependent service response body has exception key
  then dependent::Error is raised with the exception value as error.message ) do
    externals.instance_exec {
      @http = HttpResponseBodyStub.new('{"exception":{"oops":42}}')
    }
    error = assert_raises(Saver::Error) {
      creator.ready?
    }
    expected = { "oops" => 42 }
    assert_equal(expected, JsonAdapter::parse(error.message), error.message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E34', %w(
  when dependent service response body has key matching the path
  then dependent::Error is raised with no path as error.message ) do
    body = '{"unready?":true}'
    externals.instance_exec {
      @http = HttpResponseBodyStub.new(body)
    }
    error = assert_raises(Saver::Error) {
      creator.ready?
    }
    assert_equal "http response.body has no key for 'ready?':#{body}", error.message
  end

end
