# frozen_string_literal: true
require_relative 'silently'
require 'json'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require_relative 'http_json_hash/service'

class AppBase < Sinatra::Base

  def initialize
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']
  set :show_exceptions, false

  error do
    error = $!
    status(500)
    content_type('application/json')
    info = {
      exception: {
        request: {
          path:request.path,
          body:request.body.read
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path:error.path,
        args:error.args,
        name:error.name,
        body:error.body,
        message:error.message
      }
    else
      exception[:message] = error.message
    end
    diagnostic = JSON.pretty_generate(info)
    puts diagnostic
    body diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_json(name)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval {
            target.public_send(name, **json_args)
          }
          json({ name => result })
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.post_json(name)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval {
            target.public_send(name, **json_args)
          }
          new_api = { name => result }
          backwards_compatible = { id:result }
          json new_api.merge(backwards_compatible)
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_probe(name)
    get "/#{name}" do
      result = instance_eval { target.public_send(name) }
      json({ name => result })
    end
  end

  private

  def json_args
    Hash[payload.map{ |key,value| [key.to_sym, value] }]
  end

  def payload
    json_hash_parse(request.body.read)
  end

  def json_hash_parse(body)
    json = (body === '') ? {} : JSON.parse!(body)
    unless json.instance_of?(Hash)
      fail 'body is not JSON Hash'
    end
    json
  rescue JSON::ParserError
    fail 'body is not JSON'
  end

end
