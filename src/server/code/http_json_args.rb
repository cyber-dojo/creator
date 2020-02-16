# frozen_string_literal: true
require_relative 'json_hash/http/requester'
require_relative 'json_hash/parser'

class HttpJsonArgs

  def initialize(body)
    @args = JsonHash::Parser::parse(body)
    unless @args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
  rescue JsonHash::Parser::Error
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def get(path)
    case path
    when '/sha'                 then ['sha',[]]
    when '/alive'               then ['alive?',[]]
    when '/ready'               then ['ready?',[]]
    when '/create_custom_group' then ['create_custom_group',[display_name]]
    when '/create_custom_kata'  then ['create_custom_kata' ,[display_name]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def display_name
    exists_arg('display_name')
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
    JsonHash::Http::Requester::Error.new(text)
  end

end
