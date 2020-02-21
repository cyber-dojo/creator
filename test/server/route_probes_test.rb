# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class RouteProbesTest < CreatorTestBase

  def self.id58_prefix
    :a86
  end

  # - - - - - - - - - - - - - - - - -
  # 200
  # - - - - - - - - - - - - - - - - -

  qtest C15: %w(
  |GET /alive
  |has status 200
  |and returns JSON'd true in response.body
  ) do
    alive = assert_get_200 '/alive?'
    assert true?(alive), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  qtest D15: %w(
  |GET /ready
  |has status 200
  |and returns JSON'd true in response.body
  |when all http-services are ready
  ) do
    ready = assert_get_200 '/ready?'
    assert true?(ready), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  qtest E15: %w(
  |GET /ready
  |has status 200
  |and returns JSON'd false in response.body
  |when custom_start_points is not ready
  ) do
    externals.instance_exec { @custom_start_points = STUB_READY_FALSE }
    ready = assert_get_200 '/ready?'
    assert false?(ready), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  qtest F15: %w(
  |GET /ready
  |has status 200
  |and returns JSON'd false in response.body
  |when saver is not ready
  ) do
    externals.instance_exec { @saver = STUB_READY_FALSE }
    ready = assert_get_200 '/ready?'
    assert false?(ready), last_response.body
  end

  # - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - -

  qtest QN4: %w(
  |when a co-service GET
  |returns non-JSON in its response.body
  |its a 500 error
  |and...
  ) do
    http_stub('xxxx')
    assert_get_500 '/ready'
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when a co-service GET
  |returns JSON (but not a Hash) in its response.body
  |its a 500 error
  |and...
  ) do
    http_stub('[]')
    assert_get_500 '/ready'
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which contains a key "exception"
  |its a 500 error
  |and...
  ) do
    http_stub(response='{"exception":42}')
    assert_get_500('/ready')
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which does not contain a key for the called method
  |its a 500 error
  |and...
  ) do
    http_stub(response='{"wibble":42}')
    assert_get_500('/ready')
  end

  # - - - - - - - - - - - - - - - - -

  private

  STUB_READY_FALSE = OpenStruct.new(:ready? => false)

  def true?(b)
    b.instance_of?(TrueClass)
  end

  def false?(b)
    b.instance_of?(FalseClass)
  end

end
