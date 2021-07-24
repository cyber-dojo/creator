# frozen_string_literal: true
require_relative 'app_base'
require_relative 'creator'
require_relative 'escape_html_helper'
require_relative 'id_typer'
require_relative 'prober'
require_relative 'selected_helper'

class App < AppBase

  def initialize(externals)
    super(externals)
    @externals = externals
  end

  attr_reader :externals

  def creator
    Creator.new(externals)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get_delegate(Prober, :sha)
  get_delegate(Prober, :alive?)
  get_delegate(Prober, :ready?)

  # - - - - - - - - - - - - - - - - - - - - -

  get '/home', provides:[:html] do
    respond_to { |wants|
      wants.html { erb :home }
    }
  end

  get '/group', provides:[:html] do
    respond_to { |wants|
      wants.html { erb :group }
    }
  end

  get '/single', provides:[:html] do
    respond_to { |wants|
      wants.html { erb :single }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 1 : choose a problem or custom-problem

  get '/choose_problem', provides:[:html] do
    respond_to { |wants|
      wants.html {
        set_view_data(externals.exercises_start_points)
        erb :choose_problem
      }
    }
  end

  get '/choose_custom_problem', provides:[:html] do
    respond_to { |wants|
      wants.html {
        set_view_data(externals.custom_start_points)
        erb :choose_custom_problem
      }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 2 : choose a language + test-framework (not for custom-problem)

  get '/choose_ltf', provides:[:html] do
    respond_to { |wants|
      wants.html {
        set_view_data(externals.languages_start_points)
        erb :choose_ltf
      }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 3 : submit

  post '/create.json', provides:[:json] do
    respond_to { |wants|
      wants.json {
        type = json_args.delete(:type)
        if type === 'group'
          id = create_group(json_args)
        else
          id = create_kata(json_args)
        end
        json({'route':"/creator/enter?id=#{id}", 'id':"#{id}"})
      }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 4 : enter

  get '/enter', provides:[:html] do
    respond_to { |wants|
      wants.html {
        @id = params['id']
        erb :enter
      }
    }
  end

  get_delegate(IdTyper, :id_type)

  post '/enter.json', provides:[:json] do
    respond_to { |wants|
      wants.json {
        group_id = json_args[:id]
        kata_id = saver.group_join(group_id)
        if kata_id.nil?
          route = "/creator/full?id=#{group_id}"
        else
          route = "/creator/avatar?id=#{kata_id}"
        end
        json({'route':route})
      }
    }
  end

  get '/avatar', provides:[:html] do
    respond_to { |wants|
      wants.html {
        @kata_id = params['id']
        manifest = saver.kata_manifest(@kata_id)
        @avatar_index = manifest['group_index'].to_i
        erb :avatar
      }
    }
  end

  get '/full', provides:[:html] do
    respond_to { |wants|
      wants.html {
        @group_id = params['id']
        erb :full
      }
    }
  end

  get '/reenter', provides:[:html] do
    respond_to { |wants|
      wants.html {
        @group_id = params['id']
        @avatars = saver.group_joined(@group_id)
                        .map{ |group_index,v| [group_index.to_i, v["id"]] }
                        .to_h
        erb :reenter
      }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get '/build_manifest', provides:[:json] do
    respond_to { |wants|
      wants.json {
        json(creator.build_manifest(**symbolized(params)))
      }
    }
  end

  get '/build_custom_manifest', provides:[:json] do
    respond_to { |wants|
      wants.json {
        json(creator.build_custom_manifest(**symbolized(params)))
      }
    }
  end

  # - - - - - - - - - - - - - - - - - - - - -

  post '/fork_group' do
    json = fork { |manifest|
      saver.group_create([manifest], default_options)
    }
    respond_to_forked(json)
  end

  post '/fork_individual' do
    json = fork { |manifest|
      saver.kata_create(manifest, default_options)
    }
    respond_to_forked(json)
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def self.deprecated_post_json(name)
    post "/#{name}", provides:[:json] do
      respond_to { |wants|
        wants.json {
          result = creator.public_send(name, **json_args)
          backwards_compatible = { id:result }
          json backwards_compatible.merge({ name => result })
        }
      }
    end
  end

  deprecated_post_json(:deprecated_group_create_custom)
  deprecated_post_json(:deprecated_kata_create_custom)

  private

  include EscapeHtmlHelper
  include SelectedHelper

  def create_group(args)
    if args.has_key?(:display_name)
      creator.group_create_custom(**args)
    else
      args[:exercise_name] ||= nil
      creator.group_create(**args)
    end
  end

  def create_kata(args)
    if args.has_key?(:display_name)
      creator.kata_create_custom(**args)
    else
      args[:exercise_name] ||= nil
      creator.kata_create(**args)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def fork
    {     id: yield(manifest_at_index),
      forked: true
    }
  rescue => caught
    { message: caught.message,
       forked: false,
    }
  end

  def manifest_at_index
    id = params['id']
    index = params['index'].to_i
    manifest = saver.kata_manifest(id)
    files = saver.kata_event(id, index)['files']
    manifest.merge!({ 'visible_files' => files })
    # Kata we are forking from may have been in a group
    # but leave no trace of that in the manifest.
    manifest.delete('group_id')
    manifest.delete('group_index')
    manifest
  end

  def respond_to_forked(json)
    respond_to do |wants|
      wants.html { redirect "/creator/enter?id=#{json[:id]}" }
      wants.json { json(json) }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def set_view_data(start_points)
    manifests = start_points.manifests
    @display_names = manifests.keys.sort
    @display_contents = []
    @display_names.each do |name|
      visible_files = manifests[name]['visible_files']
      filename = selected(visible_files)
      content = visible_files[filename]['content']
      @display_contents << content
    end
  end

  # - - - - - - - - - - - - - - - -

  def default_options
    {}
  end

  def saver
    externals.saver
  end

end
