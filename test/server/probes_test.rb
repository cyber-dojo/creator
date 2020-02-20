# frozen_string_literal: true
require_relative 'creator_test_base'
require 'ostruct'

class ProbesTest < CreatorTestBase

  def self.id58_prefix
    :a86
  end

  # - - - - - - - - - - - - - - - - -

  test '15C', %w( GET /alive returns JSON'd true ) do
    get '/alive'
    assert_status(200)
    assert true?(json_response['alive?']), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15D',
  %w( GET /ready returns JSON'd true when all http-services are ready ) do
    get '/ready'
    assert_status(200)
    assert true?(json_response['ready?']), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15E',
  %w( GET /ready returns JSON'd false when custom_start_points is not ready ) do
    externals.instance_exec { @custom_start_points = STUB_READY_FALSE }
    get '/ready'
    assert_status(200)
    assert false?(json_response['ready?']), last_response.body
  end

  # - - - - - - - - - - - - - - - - -

  test '15F',
  %w( GET /ready returns JSON'd false when saver is not ready ) do
    externals.instance_exec { @saver = STUB_READY_FALSE }
    get '/ready'
    assert_status(200)
    assert false?(json_response['ready?']), last_response.body
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