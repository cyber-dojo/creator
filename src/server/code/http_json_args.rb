# frozen_string_literal: true
require_relative 'json_hash/http/requester'
#require_relative 'json_hash/parser'
require 'json'

# Deprecated API passes display_name in query-string
# /setup_custom_start_point/save_individual?display_name=Java%20Countdown%2C%20Round%201
# So I need HttpJsonArgs to also accept data via request.params
# Spiking to look into that...

class HttpJsonArgs

  def self.get(body, path, params)
    case path
    when '/sha'                 then ['sha',[]]
    when '/alive'               then ['alive?',[]]
    when '/ready'               then ['ready?',[]]
    when '/create_custom_group' then ['create_custom_group',[display_name(body,params)]]
    when '/create_custom_kata'  then ['create_custom_kata' ,[display_name(body,params)]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def self.display_name(body, params)
    if params.has_key?('display_name')
      params['display_name']
    else
      json(body, 'display_name')
    end
  end

  # - - - - - - - - - - - - - - - -

  def self.json(body, key)
    args = JSON.parse!(body)
    unless args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
    unless args.has_key?(key)
      raise missing(key)
    end
    args[key]
  rescue JSON::ParserError
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def self.missing(arg_name)
    request_error("#{arg_name} is missing")
  end

  # - - - - - - - - - - - - - - - -

  def self.request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    JsonHash::Http::Requester::Error.new(text)
  end

=begin
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
=end

end
