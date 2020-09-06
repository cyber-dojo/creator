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
  |GET/alive?
  |has status 200
  |returns true
  |and nothing else
  ) do
    assert_get_200(path='alive?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr[path]), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest D15: %w(
  |when all http-services are ready
  |GET/ready?
  |has status 200
  |returns true
  |and nothing else
  ) do
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr[path]), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest E15: %w(
  |when custom_start_points http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @custom_start_points=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  qtest E16: %w(
  |when exercises_start_points http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @exercises_start_points=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  qtest E17: %w(
  |when languages_start_points http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @languages_start_points=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  qtest E19: %w(
  |when runner http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @runner=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest F15: %w(
  |when model http-service is not ready
  |GET/ready?
  |has status 200
  |returns false
  |and nothing else
  ) do
    externals.instance_exec { @model=STUB_READY_FALSE }
    assert_get_200(path='ready?') do |jr|
      assert_equal [path], jr.keys, "keys:#{last_response.body}:"
      assert false?(jr[path]), "false?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest F16: %w(
  |GET/alive?
  |is used by external k8s probes
  |so obeys Postel's Law
  |and ignores any passed arguments
  ) do
    assert_get_200('alive?arg=unused') do |jr|
      assert_equal ['alive?'], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr['alive?']), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest F17: %w(
  |GET/ready?
  |is used by external k8s probes
  |so obeys Postel's Law
  |and ignores any passed arguments
  ) do
    assert_get_200('ready?arg=unused') do |jr|
      assert_equal ['ready?'], jr.keys, "keys:#{last_response.body}:"
      assert true?(jr['ready?']), "true?:#{last_response.body}:"
    end
  end

  # - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - -

  qtest QN4: %w(
  |when an external http-service
  |returns non-JSON in its response.body
  |GET/ready? is a 500 error
  ) do
    stub_model_http('xxxx')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN5: %w(
  |when an external http-service
  |returns JSON (but not a Hash) in its response.body
  |GET/ready? is a 500 error
  ) do
    stub_model_http('[]')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN6: %w(
  |when an external http-service
  |returns JSON-Hash in its response.body
  |which contains the key "exception"
  |GET/ready? is a 500 error
  ) do
    stub_model_http(response='{"exception":42}')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest QN7: %w(
  |when an external http-service
  |returns JSON-Hash in its response.body
  |which does not contain the "ready?" key
  |GET/ready? is a 500 error
  ) do
    stub_model_http(response='{"wibble":42}')
    assert_get_500('ready?') do |jr|
      assert_equal [ 'exception' ], jr.keys.sort, last_response.body
      #...
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
