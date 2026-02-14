require 'English'
require_relative 'silently'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require_relative 'http_json_hash/service'
require_relative 'json_hash_parse_helper'
require 'json'
require 'sprockets'

class AppBase < Sinatra::Base
  def initialize(externals)
    @externals = externals
    assets_dir = "#{__dir__}/assets"
    @css = File.read("#{assets_dir}/stylesheets/pre-built-app.css")
    @js  = File.read("#{assets_dir}/javascripts/pre-built-app.js")
    super(nil)
  end

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']
  set :environment, Sprockets::Environment.new

  get '/assets/app.css', provides: [:css] do
    respond_to do |format|
      format.css do
        content_type 'text/css'
        @css
      end
    end
  end

  get '/assets/app.js', provides: [:js] do
    respond_to do |format|
      format.js do
        content_type 'text/javascript'
        @js
      end
    end
  end

  def self.get_delegate(klass, name)
    get "/#{name}", provides: [:json] do
      respond_to do |format|
        format.json do
          target = klass.new(@externals)
          result = target.public_send(name, params)
          json({ name => result })
        end
      end
    end
  end

  private_class_method :get_delegate

  private

  def json_args
    @json_args ||= symbolized(json_payload)
  end

  def symbolized(hash)
    # named-args require symbolization
    hash.transform_keys(&:to_sym)
  end

  def json_payload
    request.body.rewind  # Already been read in sinatra 4.0.0 !
    json_hash_parse(request.body.read)
  end

  include JsonHashParseHelper

  set :show_exceptions, false

  error do
    error = $ERROR_INFO
    info = {
      exception: {
        request: {
          path: request.path,
          body: request.body ? request.body.read : nil
        },
        backtrace: error.backtrace
      }
    }
    exception = info[:exception]
    if error.instance_of?(::HttpJsonHash::ServiceError)
      exception[:http_service] = {
        path: error.path,
        args: error.args,
        name: error.name,
        body: error.body,
        message: error.message
      }
    else
      exception[:message] = error.message
    end
    puts JSON.pretty_generate(info)
    halt erb :error
  end
end
