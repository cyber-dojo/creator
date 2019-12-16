require_relative 'creator_test_base'
require 'net/http'
require 'ostruct'

class CreatorTest < CreatorTestBase

  def self.hex_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '191', %w( /sha is 40-char git commit sha ) do
    sha = creator.sha
    assert git_sha?(sha), sha
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( its alive ) do
    assert creator.alive?
  end

  test '602',
  %w( its ready ) do
    assert creator.ready?
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( /create_group returns the id of a newly created group ) do
    id = creator.create_group(any_manifest)
    assert group_exists?(id), id
  end

  test '703',
  %w( /create_kata returns the id of a newly created kata ) do
    id = creator.create_kata(any_manifest)
    assert kata_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -
  # 500
  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  class HttpResponseBodyStub
    def initialize(body)
      @body = body
    end
    def get(uri)
      Net::HTTP::Get.new(uri)
    end
    def start(_hostname, _port, _req)
      OpenStruct.new(body:@body)
    end
  end

  test 'E31', %w(
  when dependent service response body is not JSON
  then HttpJson::Error is raised ) do
    externals.instance_exec { @http = HttpResponseBodyStub.new('x') }
    error = assert_raises(HttpJson::Error) { creator.ready? }
    assert_equal 'http response.body is not JSON:x', error.message
  end

  # - - - - - - - - - - - - - - - - - - - - - - - - - -

  test 'E32', %w(
  when dependent service response body is not JSON Hash
  then HttpJson::Error is raised ) do
    externals.instance_exec { @http = HttpResponseBodyStub.new('[]') }
    error = assert_raises(HttpJson::Error) { creator.ready? }
    assert_equal 'http response.body is not JSON Hash:[]', error.message
  end

  private

  def git_sha?(s)
    s.size === 40 && s.each_char.all?{ |ch| is_hex?(ch) }
  end

  def is_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
