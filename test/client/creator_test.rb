# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class CreatorTest < CreatorTestBase

  def self.id58_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( create_group returns the id of a newly created group ) do
    id = creator.create_group(any_manifest)
    assert group_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - -

  test '703',
  %w( create_kata returns the id of a newly created kata ) do
    id = creator.create_kata(any_manifest)
    assert kata_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( create_group with a null manifest raises ) do
    assert_raises(Creator::Error) {
      creator.create_group(nil)
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45a',
  %w( custom.manifest(unknown_name) raises ) do
    assert_raises(CustomStartPoints::Error) {
      custom.manifest('unknown-name')
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '45b',
  %w( saver.exists?(nil) raises ) do
    assert_raises(Saver::Error) {
      saver.exists?(nil)
    }
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

  # - - - - - - - - - - - - - - - - -

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
