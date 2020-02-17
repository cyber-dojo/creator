# frozen_string_literal: true
require_relative 'creator'
require_relative 'silently'
silently { require 'sinatra/contrib' } # N x "warning: method redefined"
require 'json'
require 'sinatra/base'

class App < Sinatra::Base

  silently { register Sinatra::Contrib }
  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(app=nil, creator=Creator.new)
    super(app)
    @creator = creator
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # identity

  get '/sha', :provides => [:json] do
    json sha: @creator.sha
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing

  get '/alive', :provides => [:json] do
    json alive?: @creator.alive?
  end

  get '/ready', :provides => [:json] do
    json ready?: @creator.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # main routes
  
  post '/create_custom_group', :provides => [:html, :json] do
    id = @creator.create_custom_group(display_name)
    respond_to do |format|
      format.html { redirect "/kata/group/#{id}" }
      format.json { json id:id }
    end
  end

  post '/create_custom_kata', :provides => [:html, :json] do
    id = @creator.create_custom_kata(display_name)
    respond_to do |format|
      format.html { redirect "/kata/edit/#{id}" }
      format.json { json id:id }
    end
  end

  private

  def display_name
    payload = params
    payload = JSON.parse(request.body.read) unless params['display_name']
    payload['display_name']
  end

end
