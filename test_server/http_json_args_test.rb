require_relative 'creator_test_base'
require_relative '../http_json_args'
require_relative '../services/http_json/error'

class HttpJsonArgsTest < CreatorTestBase

  def self.hex_prefix
    'EE7'
  end

  # - - - - - - - - - - - - - - - - -

  test 'A04', %w(
  ctor raises HttpJson::Error when its string-arg is invalid JSON ) do
    expected = 'body is not JSON'
    # abc is not a valid top-level json element
    error = assert_raises(HttpJson::Error) {
      HttpJsonArgs.new('abc')
    }
    assert_equal expected, error.message
    # nil is null in json
    error = assert_raises(HttpJson::Error) {
      HttpJsonArgs.new('{"x":nil}')
    }
    assert_equal expected, error.message
    # keys have to be strings in json
    error = assert_raises(HttpJson::Error) {
      HttpJsonArgs.new('{42:"answer"}')
    }
    assert_equal expected, error.message
  end

  # - - - - - - - - - - - - - - - - -

  test 'A05', %w(
  ctor raises HttpJson::Error when its string-arg is not a JSON Hash ) do
    expected = 'body is not JSON Hash'
    error = assert_raises(HttpJson::Error) {
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

  test 'e12', 'sha has no args' do
    name,args = HttpJsonArgs.new('{}').get('/sha')
    assert_equal name, 'sha'
    assert_equal [], args
  end

  test 'e13', 'alive has no args' do
    name,args = HttpJsonArgs.new('{}').get('/alive')
    assert_equal name, 'alive?'
    assert_equal [], args
  end

  test 'e14', 'ready has no args' do
    name,args = HttpJsonArgs.new('{}').get('/ready')
    assert_equal name, 'ready?'
    assert_equal [], args
  end

  # - - - - - - - - - - - - - - - - -

  test '1BC', %w( create_group has one arg ) do
    any_manifest = manifest
    body = { manifest:any_manifest }.to_json
    name,args = HttpJsonArgs.new(body).get('/create_group')
    assert_equal 'create_group', name
    assert_equal any_manifest, args[0]
  end

  test '1BD', %w( create_group has one arg ) do
    any_manifest = manifest
    body = { manifest:any_manifest }.to_json
    name,args = HttpJsonArgs.new(body).get('/create_kata')
    assert_equal 'create_kata', name
    assert_equal any_manifest, args[0]
  end

  # - - - - - - - - - - - - - - - - -

  test 'C14', %w( unknown path raises HttpJson::Error ) do
    error = assert_raises(HttpJson::Error) {
      HttpJsonArgs.new('').get('/unknown_path')
    }
    assert_equal 'unknown path', error.message
  end

  # - - - - - - - - - - - - - - - - -
  # missing arguments
  # - - - - - - - - - - - - - - - - -

  test '7B1',
  %w( missing manifest raises HttpJson::RequestError ) do
    assert_missing_manifest('/create_group')
    assert_missing_manifest('/create_kata')
  end

  private

  def assert_missing_manifest(path)
    error = assert_raises(HttpJson::Error) {
      HttpJsonArgs.new({}.to_json).get(path)
    }
    assert_equal 'manifest is missing', error.message
  end

end
