# frozen_string_literal: true
require 'json'

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_name:, options:default_options)
    manifest = custom_start_points.manifest(display_name)
    create_group(manifest, options)
  end

  def kata_create_custom(display_name:, options:default_options)
    manifest = custom_start_points.manifest(display_name)
    create_kata(manifest, options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create(exercise_name:, language_name:, options:default_options)
    manifest = languages_start_points.manifest(language_name)
    unless exercise_name.nil?
      exercise = exercises_start_points.manifest(exercise_name)
      manifest['visible_files'].merge!(exercise['visible_files'])
      manifest['exercise'] = exercise['display_name']
    end
    create_group(manifest, options)
  end

  def kata_create(exercise_name:, language_name:, options:default_options)
    manifest = languages_start_points.manifest(language_name)
    unless exercise_name.nil?
      exercise = exercises_start_points.manifest(exercise_name)
      manifest['visible_files'].merge!(exercise['visible_files'])
      manifest['exercise'] = exercise['display_name']
    end
    create_kata(manifest, options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_group_create_custom(display_name:)
    manifest = custom_start_points.manifest(display_name)
    create_group(manifest, default_options)
  end

  def deprecated_kata_create_custom(display_name:)
    manifest = custom_start_points.manifest(display_name)
    create_kata(manifest, default_options)
  end

  private

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  #- - - - - - - - - - - - - - - - - -

  def create_group(manifest, options)
    id = model.group_create([manifest], options)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  #- - - - - - - - - - - - - - - - - -

  def create_kata(manifest, options)
    id = model.kata_create(manifest, options)
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  #- - - - - - - - - - - - - - - - - -

  def pull_image_onto_nodes(id, image_name)
    # runner is deployed as a kubernetes daemonSet which
    # means you cannot make http requests to individual runners.
    # So instead, send the request many times (it is asynchronous),
    # and rely on one request reaching each node. If a node is missed
    # it simply means the image will get pulled onto the node on the
    # first run_cyber_dojo_sh() call, and at the browser, the [test]
    # will result in an hour-glass icon.
    16.times { runner.pull_image(id, image_name) }
  end

  #- - - - - - - - - - - - - - - - - -

  def custom_start_points
    @externals.custom_start_points
  end

  def exercises_start_points
    @externals.exercises_start_points
  end

  def languages_start_points
    @externals.languages_start_points
  end

  #- - - - - - - - - - - - - - - - - -

  def model
    @externals.model
  end

  def runner
    @externals.runner
  end

end
