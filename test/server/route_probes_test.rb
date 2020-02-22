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
  |GET /alive?
  |has status 200
  |returns true
  |and nothing else
  ) do
    assert_get_200(path='alive?') do |jr|
      assert_equal [path], jr.keys, last_response.body
      assert true?(jr[path]), last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest D15: %w(
  |GET /ready?
  |has status 200
  |returns true when all http-services are ready
  |and nothing else
  ) do
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, last_response.body
      assert true?(jr[path]), last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest E15: %w(
  |GET /ready?
  |has status 200
  |returns false when custom_start_points is not ready
  |and nothing else
  ) do
    externals.instance_exec { @custom_start_points=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, last_response.body
      assert false?(jr[path]), last_response.body
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest F15: %w(
  |GET /ready?
  |has status 200
  |returns false when saver is not ready
  |and nothing else
  ) do
    externals.instance_exec { @saver=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, last_response.body
      assert false?(jr[path]), last_response.body
    end
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
    saver_http_stub('xxxx')
    assert_get_500('ready?') do |jr|
      assert_equal ['exception','request','service'], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when a co-service GET
  |returns JSON (but not a Hash) in its response.body
  |its a 500 error
  |and...
  ) do
    saver_http_stub('[]')
    assert_get_500('ready?') do |jr|
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which contains a key "exception"
  |its a 500 error
  |and...
  ) do
    saver_http_stub(response='{"exception":42}')
    assert_get_500('ready?') do |jr|
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when a co-service GET
  |returns JSON-Hash in its response.body
  |which does not contain a key for the called method
  |its a 500 error
  |and...
  ) do
    saver_http_stub(response='{"wibble":42}')
    assert_get_500('ready?') do |jr|
    end
  end

  private

  STUB_READY_FALSE = OpenStruct.new(:ready? => false)

  def true?(b)
    b.instance_of?(TrueClass)
  end

  def false?(b)
    b.instance_of?(FalseClass)
  end

end
