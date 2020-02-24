# frozen_string_literal: true
require_relative 'silently'
require 'json'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require_relative 'http_json_hash/service'

class JsonAppBase < Sinatra::Base

  def initialize
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_json(name)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval {
            target.public_send(name, **args)
          }
          json({ name => result })
        }
      end
    end
  end

  get_json(:sha) # identity

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.post_json(name)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval {
            target.public_send(name, **args)
          }
          new_api = { name => result }
          backwards_compatible = { id:result }
          json new_api.merge(backwards_compatible)
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.probe(name)
    get "/#{name}" do
      result = instance_eval { target.public_send(name) }
      json({ name => result })
    end
  end

  probe(:alive?) # curl/k8s
  probe(:ready?) # curl/k8s

  # - - - - - - - - - - - - - - - - - - - - - -

  set :show_exceptions, false

  error do
    error = $!
    status(500)
    content_type('application/json')
    info = { exception: error.message }
    if error.instance_of?(::HttpJsonHash::ServiceError)
      info[:request] = {
        path:request.path
        #body:request.body.read,
      }
      info[:service] = {
        path:error.path,
        args:error.args,
        name:error.name,
        body:error.body
      }
    end
    diagnostic = JSON.pretty_generate(info)
    puts diagnostic
    body diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def args
    payload = json_hash_parse(request.body.read)
    x = Hash[payload.map{ |key,value| [key.to_sym, value] }]
    #dump_args(x)
    x
  end

  private

  def json_hash_parse(body)
    #dump_payload(body)
    json = (body === '') ? {} : JSON.parse!(body)
    unless json.instance_of?(Hash)
      fail 'body is not JSON Hash'
    end
    json
  rescue JSON::ParserError
    fail 'body is not JSON'
  end

  # - - - - - - - - - - - - - - - - - - - - - -

=begin
  def dump_payload(body)
    if request.path === '/sha'
      puts "request.content_type:#{request.content_type}:"
      puts "params:#{params}:"
      puts "body:#{body}:"
    end
  end

  def dump_args(args)
    if request.path === '/sha'
      puts "args (for **)==#{args}"
    end
  end
=end

end
