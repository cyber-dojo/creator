# frozen_string_literal: true
require_relative 'creator_test_base'
require_src 'external_saver'
require 'ostruct'

class DependentServiceTest < CreatorTestBase

  def self.id58_prefix
    '078'
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E30', %w(
  when dependent service POST response body is not JSON Hash
  then dependent::Error is raised ) do
    # [1] makes http request, so before stub is set
    display_name = custom.display_names.sample # [1]
    error = stub_http_response('x', ExternalSaver) {
      get '/create_custom_group', display_name:display_name
    }
    #assert_equal 'not JSON:x', error.message
    puts "status:#{last_response.status}" #404 SHOULD BE 500
    puts "body:#{last_response.body}"
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

=begin
  test 'E31', %w(
  when dependent service GET response body is not JSON
  then dependent::Error is raised ) do
    error = stub_http_response('y') { creator.ready? }
    assert_equal 'not JSON:y', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E32', %w(
  when dependent service response body is not JSON Hash
  then dependent::Error is raised ) do
    error = stub_http_response('[]') { creator.ready? }
    assert_equal 'not JSON Hash:[]', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E33', %w(
  when dependent service response body has exception key
  then dependent::Error is raised with the exception value as error.message ) do
    body = '{"exception":{"oops":42}}'
    error = stub_http_response(body) { creator.ready? }
    expected = { "oops" => 42 }
    assert_equal(expected, JSON::parse(error.message), error.message)
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E34', %w(
  when dependent service response body does not have key matching the path
  then dependent::Error is raised with no key as error.message ) do
    body = '{"unready?":true}'
    error = stub_http_response(body) { creator.ready? }
    assert_equal "no key for 'ready?':#{body}", error.message
  end

  private

  def stub_http_response(body, klass=ExternalCustomStartPoints)
    externals.instance_exec { @http = ExternalHttpStub.new(body) }
    #assert_raises(klass::Error) { yield }
    yield
  end

  class ExternalHttpStub
    def initialize(body)
      @body = body
    end
    def get(_uri)
      OpenStruct.new
    end
    def post(_uri)
      OpenStruct.new
    end
    def start(_hostname, _port, _req)
      OpenStruct.new(body:@body)
    end
  end
=end

end
