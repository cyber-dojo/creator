# frozen_string_literal: true
require_relative 'creator'
require_relative 'silently'
require 'json'
require 'sinatra/base'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"

class App < Sinatra::Base

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(app=nil, creator=nil)
    super(app)
    @creator = creator
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # identity

  get '/sha', :provides => [:json] do
    rescued_respond_to do |format|
      format.json { json sha: creator.sha(**args) }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing

  get '/alive', :provides => [:json] do
    rescued_respond_to do |format|
      format.json { json alive?: creator.alive?(**args) }
    end
  end

  get '/ready', :provides => [:json] do
    rescued_respond_to do |format|
      format.json { json ready?: creator.ready?(**args) }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # main routes

  post '/create_custom_group', :provides => [:html, :json] do
    rescued_respond_to do |format|
      id = creator.create_custom_group(**args)
      format.html { redirect "/kata/group/#{id}" }
      format.json { json id:id }
    end
  end

  post '/create_custom_kata', :provides => [:html, :json] do
    rescued_respond_to do |format|
      id = creator.create_custom_kata(**args)
      format.html { redirect "/kata/edit/#{id}" }
      format.json { json id:id }
    end
  end

  private

  def creator
    # In production, @creator is nil, each request => Creator.new
    # In testing, @creator is non-nil to allow stubbing
    @creator || Creator.new
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def rescued_respond_to
    respond_to { |format| yield format }
  rescue Exception => error
    if error.is_a?(RequestError)
      #puts "400:#{error.message}:"
      response.status = 400
      return
    end
    if error.is_a?(ArgumentError)
      if r = error.message.match('(missing|unknown) keyword(s?): (.*)')
        #puts "400:#{r[1]} argument#{r[2]}: #{r[3]}"
        response.status = 400
        return
      end
    end

    #puts "500:#{error.message}:"
    response.status = 500
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def args
    Hash[payload.map{ |key,value| [key.to_sym, value] }]
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def payload
    if request.path === '/sha'
      #puts "request.content_type:#{request.content_type}:"
    end
    if request.content_type === 'application/json'
      json_hash_parse(request.body.read)
    else
      params
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def dump_payload
    puts '~~~~~~~~'
    puts "params:#{params}:"
    puts "body:#{body}:"
    puts '~~~~~~~~'
  end

  def json_hash_parse(body)
    #dump_payload
    json = (body === '') ? {} : JSON.parse!(body)
    unless json.instance_of?(Hash)
      fail RequestError, 'body is not JSON Hash'
    end
    json
  rescue JSON::ParserError
    fail RequestError, 'body is not JSON'
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  class RequestError < RuntimeError
    def initialize(message)
      super
    end
  end

end
