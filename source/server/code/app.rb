# frozen_string_literal: true
require_relative 'app_base'
require_relative 'creator'
require_relative 'escape_html_helper'
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
  # Step 1 : choose a type (group or single)

  get '/choose_type', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :choose_type
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 2 : choose a problem or custom-problem

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
  # Step 3 : choose a language + test-framework (not for custom-problem)

  get '/choose_ltf', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.languages_start_points)
        erb :choose_ltf
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 4 : submit

  get '/submit', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :submit
      end
    end
  end

  get '/create', provides:[:html] do
    respond_to do |format|
      format.html do
        type = params_args.delete(:type)
        if type === 'group'
          id = create_group
        else
          id = create_kata
        end
        redirect "/home/enter?id=#{id}"
      end
    end
  end

  def create_group
    if params_args.has_key?(:display_name)
      creator.group_create_custom(**params_args)
    else
      params_args[:exercise_name] ||= nil
      creator.group_create(**params_args)
    end
  end

  def create_kata
    if params_args.has_key?(:display_name)
      creator.kata_create_custom(**params_args)
    else
      params_args[:exercise_name] ||= nil      
      creator.kata_create(**params_args)
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - -
  # Custom

  get '/group_custom_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.custom_start_points)
        erb :group_custom
      end
    end
  end

  get '/group_custom_create', provides:[:html] do
    respond_to do |format|
      format.html do
        id = creator.group_create_custom(**params_args)
        redirect "/kata/group/#{id}"
      end
    end
  end

  # - - - -

  get '/kata_custom_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.custom_start_points)
        erb :kata_custom
      end
    end
  end

  get '/kata_custom_create', provides:[:html] do
    respond_to do |format|
      format.html do
        id = creator.kata_create_custom(**params_args)
        redirect "/kata/edit/#{id}"
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Exercise

  get '/group_exercise_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.exercises_start_points)
        erb :group_exercise
      end
    end
  end

  # - - - -

  get '/kata_exercise_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.exercises_start_points)
        erb :kata_exercise
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Language

  get '/group_language_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.languages_start_points)
        erb :group_language
      end
    end
  end

  get '/group_language_create', provides:[:html] do
    respond_to do |format|
      format.html {
        id = creator.group_create(**params_args)
        redirect "/kata/group/#{id}"
      }
    end
  end

  # - - - -

  get '/kata_language_choose', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.languages_start_points)
        erb :kata_language
      end
    end
  end

  get '/kata_language_create', provides:[:html] do
    respond_to do |format|
      format.html {
        id = creator.kata_create(**params_args)
        redirect "/kata/edit/#{id}"
      }
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -

  deprecated_post_json(:deprecated_group_create_custom)
  deprecated_post_json(:deprecated_kata_create_custom)

  private

  def params_args
    @params_args ||= symbolized(params)
  end

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

  include EscapeHtmlHelper
  include SelectedHelper

end
