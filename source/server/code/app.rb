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
