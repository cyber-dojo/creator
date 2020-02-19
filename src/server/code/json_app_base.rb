require_relative 'silently'
require 'json'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"

class JsonAppBase < Sinatra::Base

  def initialize(target)
    super(nil)
    @target = target
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -

  set :show_exceptions, false

  error do
    # TODO: {"exception":...}
    # TODO: let exception from service (eg saver) propoagate? or wrap?
    # TODO: return prettified json exception in response.body
    # TODO: log prettified json exception to stdout too
    error = $!
    puts "(500):#{error.message}:"
    status(500)
    #content_type('application/json')
    body(error.message)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.get_json(name)
    get "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval { @target.public_send(name, **args) }
          new_api = { name => result }
          json new_api
        }
      end
    end
  end

  def self.post_json(name)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = instance_eval { @target.public_send(name, **args) }
          new_api = { name => result }
          backwards_compatible = { id:result }
          json new_api.merge(backwards_compatible)
        }
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def args
    payload = json_hash_parse(request.body.read)
    x = Hash[payload.map{ |key,value| [key.to_sym, value] }]
    #dump_args(x)
    x
  end

  # - - - - - - - - - - - - - - - - - - - - - -

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

end
