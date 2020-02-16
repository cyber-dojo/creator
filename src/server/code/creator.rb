# frozen_string_literal: true
require_relative 'externals'
require_relative 'silent_warnings'
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'json_hash/generator'
require_relative 'saver_asserter'
require_silent 'sinatra/contrib' # N x "warning: method redefined"
require 'json'
require 'sinatra/base'

class Creator < Sinatra::Base
  silent_warnings { register Sinatra::Contrib }

  set :port, ENV['PORT']

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(app=nil, externals=Externals.new)
    super(app)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # identity

  get '/sha', :provides => [:json] do
    json sha:ENV['SHA']
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing

  get '/alive', :provides => [:json] do
    json alive?:true
  end

  get '/ready', :provides => [:json] do
    json ready?:ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  post '/create_custom_group', :provides => [:html, :json] do
    manifest = custom_start_points.manifest(display_name)
    id = create_group(manifest)
    respond_to do |format|
      format.html { redirect "/kata/group/#{id}" }
      format.json { json id:id }
    end
  end

  post '/create_custom_kata', :provides => [:html, :json] do
    manifest = custom_start_points.manifest(display_name)
    id = create_kata(manifest)
    respond_to do |format|
      format.html { redirect "/kata/edit/#{id}" }
      format.json { json id:id }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # ...

  private

  include IdPather # group_id_path, kata_id_path

  def ready?
    services = []
    services << custom_start_points
    services << saver
    services.all?{ |service| service.ready? }
  end

  def display_name
    payload = params
    payload = JSON.parse(request.body.read) unless params['display_name']
    payload['display_name']
  end

  def create_group(manifest)
    set_version(manifest)
    set_time_stamp(manifest)
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    saver_asserter.batch(
      group_manifest_write_cmd(id, pretty_json(manifest)),
      group_katas_write_cmd(id, '')
    )
    id
  end

  # - - - - - - - - - - - - - -

  def create_kata(manifest)
    set_version(manifest)
    set_time_stamp(manifest)
    id = manifest['id'] = IdGenerator.new(@externals).kata_id
    event_summary = {
      'index' => 0,
      'time' => manifest['created'],
      'event' => 'created'
    }
    event0 = {
      'files' => manifest['visible_files']
    }
    saver_asserter.batch(
      kata_manifest_write_cmd(id, pretty_json(manifest)),
      kata_events_write_cmd(id, pretty_json(event_summary)),
      kata_event_write_cmd(id, 0, pretty_json(event0.merge(event_summary)))
    )
    id
  end

  #- - - - - - - - - - - - - - - - - -

  def pretty_json(obj)
    JsonHash::Generator::pretty(obj)
  end

  #- - - - - - - - - - - - - - - - - -

  def set_version(manifest)
    manifest['version'] = 1
  end

  #- - - - - - - - - - - - - - - - - -

  def set_time_stamp(manifest)
    manifest['created'] = time.now
  end

  #- - - - - - - - - - - - - - - - - -

  def group_manifest_write_cmd(id, manifest_src)
    ['write', group_manifest_filename(id), manifest_src]
  end

  def group_manifest_filename(id)
    group_id_path(id, 'manifest.json')
  end

  def group_katas_write_cmd(id, src)
    ['write', group_katas_filename(id), src]
  end

  def group_katas_filename(id)
    group_id_path(id, 'katas.txt')
  end

  #- - - - - - - - - - - - - - - - - -

  def kata_manifest_write_cmd(id, manifest_src)
    ['write', kata_manifest_filename(id), manifest_src]
  end

  def kata_manifest_filename(id)
    kata_id_path(id, 'manifest.json')
  end

  def kata_events_write_cmd(id, event0_src)
    ['write', kata_events_filename(id), event0_src]
  end

  def kata_events_filename(id)
    kata_id_path(id, 'events.json')
  end

  def kata_event_write_cmd(id, index, event_src)
    ['write', kata_event_filename(id,index), event_src]
  end

  def kata_event_filename(id, index)
    kata_id_path(id, "#{index}.event.json")
  end

  #- - - - - - - - - - - - - - - - - -

  def saver_asserter
    SaverAsserter.new(saver)
  end

  def custom_start_points
    @externals.custom_start_points
  end

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end
