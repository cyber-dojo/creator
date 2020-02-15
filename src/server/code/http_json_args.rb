# frozen_string_literal: true
require_relative 'services/http_json_hash/requester'
require_relative 'json_hash'

class HttpJsonArgs

  def initialize(body)
    @args = JsonHash::parse(body)
    unless @args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
  rescue JsonHash::ParseError
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def get(path)
    case path
    when '/sha'          then ['sha',[]]
    when '/alive'        then ['alive?',[]]
    when '/ready'        then ['ready?',[]]
    when '/create_group' then ['create_group',[manifest]]
    when '/create_kata'  then ['create_kata',[manifest]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def manifest
    exists_arg('manifest')
  end

  # - - - - - - - - - - - - - - - -

  def exists_arg(name)
    unless @args.has_key?(name)
      raise missing(name)
    end
    arg = @args[name]
    arg
  end

  # - - - - - - - - - - - - - - - -

  def missing(arg_name)
    request_error("#{arg_name} is missing")
  end

  # - - - - - - - - - - - - - - - -

  def request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    HttpJsonHash::Requester::Error.new(text)
  end

end
