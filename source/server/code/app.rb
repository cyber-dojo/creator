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
  # Step 1 : choose a problem

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
  # Step 2 : choose a language + test-framework

  get '/choose_ltf', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data(externals.languages_start_points)
        erb :choose_ltf
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 3 : choose a type (group or individual)

  get '/choose_type', provides:[:html] do
    respond_to do |format|
      format.html do
        erb :choose_type
      end
    end
  end

  # - - - - - - - - - - - - - - - - - - - - -
  # Step 4 : create the exercise

  get '/create_group_exercise', provides:[:html] do
    respond_to do |format|
      format.html do
        #TODO: params: problem or custom_problem?
        #id = creator.group_create_custom(**params_args)
        #id = creator.group_create(**params_args)
        redirect "/kata/group/#{id}"
      end
    end
  end

  get '/create_individual_exercise', provides:[:html] do
    respond_to do |format|
      format.html do
        #TODO: params: problem or custom_problem?
        #id = creator.kata_create_custom(**params_args)
        #id = creator.kata_create(**params_args)
        redirect "/kata/edit/#{id}"
      end
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
    symbolized(params)
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
