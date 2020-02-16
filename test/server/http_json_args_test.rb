# frozen_string_literal: true
require_relative 'creator_test_base'
require_src 'http_json_args'
require_src 'json_hash/http/requester'

class HttpJsonArgsTest < CreatorTestBase

  def self.id58_prefix
    'wE7'
  end

  # - - - - - - - - - - - - - - - - -

  test 'A04', %w(
  when its string-arg is invalid JSON
  ctor raises JsonHash::Http::Requester::Error
  ) do
    expected = 'body is not JSON'
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new('abc')
    }
    assert_equal expected, error.message, :not_top_level_JSON
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new('{"x":nil}')
    }
    assert_equal expected, error.message, :nil_is_null_in_JSON
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new('{42:"answer"}')
    }
    assert_equal expected, error.message, :JSON_keys_must_be_strings
  end

  # - - - - - - - - - - - - - - - - -

  test 'A05', %w(
  when its string-arg is not a JSON Hash
  ctor raises JsonHash::Http::Requester::Error
  ) do
    expected = 'body is not JSON Hash'
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new('[]')
    }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test 'c89', %w(
  ctor does not raise when body is empty string which is
  useful for kubernetes liveness/readyness probes ) do
    HttpJsonArgs.new('')
  end

  test '691',
  %w( ctor does not raise when string-arg is valid json ) do
    HttpJsonArgs.new('{}')
    HttpJsonArgs.new('{"answer":42}')
  end

  # - - - - - - - - - - - - - - - - -

  test 'e12', '/sha has no args' do
    name,args = HttpJsonArgs.new('{}').get('/sha')
    assert_equal name, 'sha'
    assert_equal [], args
  end

  test 'e13', '/alive has no args' do
    name,args = HttpJsonArgs.new('{}').get('/alive')
    assert_equal name, 'alive?'
    assert_equal [], args
  end

  test 'e14', '/ready has no args' do
    name,args = HttpJsonArgs.new('{}').get('/ready')
    assert_equal name, 'ready?'
    assert_equal [], args
  end

  # - - - - - - - - - - - - - - - - -

  test '1BC', %w( /create_custom_group has one arg called display_name ) do
    display_name = any(custom.display_names)
    body = { display_name:display_name }.to_json
    name,args = HttpJsonArgs.new(body).get('/create_custom_group')
    assert_equal 'create_custom_group', name
    assert_equal display_name, args[0]
  end

  test '1BD', %w( /create_custom_kata has one arg called display_name ) do
    display_name = any(custom.display_names)
    body = { display_name:display_name }.to_json
    name,args = HttpJsonArgs.new(body).get('/create_custom_kata')
    assert_equal 'create_custom_kata', name
    assert_equal display_name, args[0]
  end

  # - - - - - - - - - - - - - - - - -

  test 'C14', %w(
  unknown path
  raises JsonHash::Http::Requester::Error
  ) do
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new('').get('/unknown_path')
    }
    assert_equal 'unknown path', error.message
  end

  # - - - - - - - - - - - - - - - - -
  # missing arguments
  # - - - - - - - - - - - - - - - - -

  test '7B1', %w(
  /create_custom_group with missing manifest arg
  raises JsonHash::Http::Requester::Error
  ) do
    assert_missing_display_name('/create_custom_group')
  end

  test '7B2', %w(
  /create_custom_kata with missing manifest arg
  raises JsonHash::Http::Requester::Error
  ) do
    assert_missing_display_name('/create_custom_kata')
  end

  private

  def assert_missing_display_name(path)
    error = assert_raises(JsonHash::Http::Requester::Error) {
      HttpJsonArgs.new({}.to_json).get(path)
    }
    assert_equal 'display_name is missing', error.message
  end

end
