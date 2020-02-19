# frozen_string_literal: true
require_relative 'creator'
require_relative 'silently'
require 'json'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"

class App < Sinatra::Base

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']
  set :show_exceptions, false

  #TODO: {"exception":...}
  #TODO: let exception from service (eg saver) propoagate? or wrap?
  error do
    error = $!
    puts "(500):#{error.message}:"
    status(500)
    #content_type('application/json')
    body(error.message)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.json_get(name)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          json name => instance_eval {
            creator.public_send(name, **args)
          }
        }
      end
    end
  end

  def self.json_post(name)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          json name => instance_eval {
            creator.public_send(name, **args)
          }
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(app=nil, creator=nil)
    super(app)
    @creator = creator
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # identity
  json_get(:sha)

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing
  json_get(:alive?)
  json_get(:ready?)

  # - - - - - - - - - - - - - - - - - - - - - -
  # main routes
  json_post(:create_custom_group)
  json_post(:create_custom_kata)

  private

  def creator
    # In production, @creator is nil, each request => Creator.new
    # In testing, @creator is non-nil to allow stubbing
    @creator || Creator.new
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dump_args(args)
    if request.path === '/sha'
      puts "args (for **)==#{args}"
    end
  end

  def args
    payload = json_hash_parse(request.body.read)
    x = Hash[payload.map{ |key,value| [key.to_sym, value] }]
    #dump_args(x)
    x
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dump_payload(body)
    if request.path === '/sha'
      puts "request.content_type:#{request.content_type}:"
      puts "params:#{params}:"
      puts "body:#{body}:"
    end
  end

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

end
