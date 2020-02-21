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
    # TODO: propagate exception from service (custom,saver) as is
    # TODO: else wrap inside {"exception":...}
    # TODO: return prettified json exception in response.body
    # TODO: log prettified json exception to stdout too
    error = $!
    status(500)
    content_type('application/json')
    diagnostic = JSON.pretty_generate({
      exception: error.message
    })
    puts diagnostic
    body diagnostic
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def self.probe(name)
    get "/#{name}" do
      result = instance_eval { @target.public_send(name) }
      new_api = { name => result }
      json new_api
    end
  end

  # curl/k8s
  probe(:alive?)
  probe(:ready?)

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
