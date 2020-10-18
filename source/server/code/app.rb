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

  get_delegate(Prober, :alive?)
  get_delegate(Prober, :ready?)
  get_delegate(Prober, :sha)

  # - - - - - - - - - - - - - - - - - - - - -

  get '/home', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :home
      end
    end
  end

  get '/group', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :group
      end
    end
  end

  get '/single', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :single
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 1 : choose a problem or custom-problem

  get '/choose_problem', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.exercises_start_points)
        erb :choose_problem
      end
    end
  end

  get '/choose_custom_problem', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.custom_start_points)
        erb :choose_custom_problem
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 2 : choose a language + test-framework (not for custom-problem)

  get '/choose_ltf', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.languages_start_points)
        erb :choose_ltf
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 3 : submit

  get '/confirm', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :confirm
      end
    end
  end

  post '/create.json', provides:[:json] do
    respond_to do |format|
      format.json do
        type = json_args.delete(:type)
        if type === 'group'
          id = create_group(json_args)
        else
          id = create_kata(json_args)
        end
        json({'route':"/creator/enter?id=#{id}"})
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  get '/enter', provides:[:html] do
    respond_to do |format|
      format.html do
        @id = params['id'] || ''
        erb :enter
      end
    end
  end

  get_delegate(IdTyper, :id_type)

  # - - - - - - - - - - - - - - - - - - - - -

  post '/enter.json', provides:[:json] do
    respond_to do |format|
      format.json do
        group_id = json_args[:id]
        kata_id = model.group_join(group_id)
        if kata_id.nil?
          route = "/creator/full?id=#{group_id}"
        else
          route = "/creator/avatar?id=#{kata_id}"
        end
        json({'route':route})
      end
    end
  end

  get '/avatar', provides:[:html] do
    respond_to do |format|
      format.html do
        @kata_id = params['id']
        manifest = model.kata_manifest(@kata_id)
        @avatar_index = manifest['group_index'].to_i
        erb :avatar
      end
    end
  end

  get '/full', provides:[:html] do
    respond_to do |format|
      format.html do
        @group_id = params['id']
        erb :full
      end
    end
  end

  get '/reenter', provides:[:html] do
    respond_to do |format|
      format.html do
        @group_id = params['id']
        @avatars = model.group_avatars(@group_id).to_h
        erb :reenter
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def self.deprecated_post_json(name)
    post "/#{name}", provides:[:json] do
      respond_to do |format|
        format.json {
          result = creator.public_send(name, **json_args)
          backwards_compatible = { id:result }
          json backwards_compatible.merge({name => result})
        }
      end
    end
  end

  deprecated_post_json(:deprecated_group_create_custom)
  deprecated_post_json(:deprecated_kata_create_custom)

  private

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

  private

  include EscapeHtmlHelper
  include SelectedHelper

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

  def model
    externals.model
  end

end
