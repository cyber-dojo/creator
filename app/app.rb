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

  get_delegate(Prober, :sha)
  get_delegate(Prober, :alive?)
  get_delegate(Prober, :ready?)

  get '/home', provides: [:html] do
    @hostname = ENV.fetch('CYBER_DOJO_ENV', 'none')
    respond_to do |wants|
      wants.html { erb :home }
    end
  end

  get '/choose_problem', provides: [:html] do
    respond_to do |wants|
      wants.html do
        self.data_source = externals.exercises_start_points
        erb :choose_problem
      end
    end
  end

  get '/choose_custom_problem', provides: [:html] do
    respond_to do |wants|
      wants.html do
        self.data_source = externals.custom_start_points
        erb :choose_custom_problem
      end
    end
  end

  get '/choose_ltf', provides: [:html] do
    respond_to do |wants|
      wants.html do
        self.data_source = externals.languages_start_points
        erb :choose_ltf
      end
    end
  end

  get '/choose_type', provides: [:html] do
    respond_to do |wants|
      wants.html do
        erb :choose_type
      end
    end
  end

  post '/create.json', provides: [:json] do
    respond_to do |wants|
      args = json_args
      type = args.delete(:type)
      id = create(type, args)
      url = "/creator/enter?id=#{id}"
      wants.json { json({ 'route' => url, 'id' => id }) }
    end
  end

  get '/enter', provides: [:html] do
    respond_to do |wants|
      wants.html do
        @id = params['id']
        erb :enter
      end
    end
  end

  get_delegate(IdTyper, :id_type)

  post '/enter.json', provides: [:json] do
    respond_to do |wants|
      wants.json do
        group_id = json_args[:id]
        kata_id = saver.group_join(group_id)
        if kata_id.nil?
          json('route' => "/creator/full?id=#{group_id}")
        else
          group_index = saver.kata_manifest(kata_id)['group_index']
          json('route' => "/creator/avatar?id=#{kata_id}",
               'id' => kata_id,
               'group_index' => group_index)
        end
      end
    end
  end

  get '/avatar', provides: [:html] do
    respond_to do |wants|
      wants.html do
        @kata_id = params['id']
        manifest = saver.kata_manifest(@kata_id)
        @avatar_index = manifest['group_index'].to_i
        erb :avatar
      end
    end
  end

  get '/full', provides: [:html] do
    respond_to do |wants|
      wants.html do
        @group_id = params['id']
        erb :full
      end
    end
  end

  get '/reenter', provides: [:html] do
    respond_to do |wants|
      wants.html do
        @group_id = params['id']
        @avatars = saver.group_joined(@group_id)
                        .map { |group_index, v| [group_index.to_i, v['id']] }
                        .to_h
        erb :reenter
      end
    end
  end

  private

  include EscapeHtmlHelper
  include SelectedHelper

  def create(type, args)
    if type == 'group'
      create_group(args)
    else
      create_kata(args)
    end
  end

  def create_group(args)
    if args.key?(:display_name)
      creator.group_create_custom(**args)
    else
      creator.group_create(**args)
    end
  end

  def create_kata(args)
    if args.key?(:display_name)
      creator.kata_create_custom(**args)
    else
      creator.kata_create(**args)
    end
  end

  def data_source=(start_points)
    manifests = start_points.manifests
    @display_names = manifests.keys.sort_by { |name| name.downcase }
    @display_contents = []
    @display_names.each do |name|
      visible_files = manifests[name]['visible_files']
      filename = selected(visible_files)
      content = visible_files[filename]['content']
      @display_contents << content
    end
  end

  def saver
    externals.saver
  end
end
