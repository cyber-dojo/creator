# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require 'json'

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing + identity

  def alive?
    true
  end

  def ready?
    dependent_services.all?(&:ready?)
  end

  def sha
    ENV['SHA']
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_names:, options:default_options)
    manifest = custom_start_points.manifest(display_names[0])
    create_group(manifest, options)
  end

  def kata_create_custom(display_name:, options:default_options)
    manifest = custom_start_points.manifest(display_name)
    create_kata(manifest, options)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create(exercise_name:, languages_names:, options:default_options)
    em = exercises_start_points.manifest(exercise_name)
    manifest = languages_start_points.manifest(languages_names[0])
    manifest['visible_files'].merge!(em['visible_files'])
    manifest['exercise'] = em['display_name']
    create_group(manifest, options)
  end

  def kata_create(exercise_name:, language_name:, options:default_options)
    em = exercises_start_points.manifest(exercise_name)
    manifest = languages_start_points.manifest(language_name)
    manifest['visible_files'].merge!(em['visible_files'])
    manifest['exercise'] = em['display_name']
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
  # group

  def create_group(manifest, _options)
    set_version(manifest)
    set_time_stamp(manifest)
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    saver.assert_all([
      group_manifest_create_cmd(id, pretty_json(manifest)),
      group_katas_create_cmd(id, '')
    ])
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  def group_manifest_create_cmd(id, manifest_src)
    saver.file_create_command(group_manifest_filename(id), manifest_src)
  end

  def group_katas_create_cmd(id, src)
    saver.file_create_command(group_katas_filename(id), src)
  end

  #- - - - - - - - - - - - - - - - - -
  # kata

  def create_kata(manifest, _options)
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
    saver.assert_all([
      kata_manifest_create_cmd(id, pretty_json(manifest)),
      kata_events_create_cmd(id, pretty_json(event_summary)),
      kata_event_create_cmd(id, 0, pretty_json(event0.merge(event_summary)))
    ])
    pull_image_onto_nodes(id, manifest['image_name'])
    id
  end

  def kata_manifest_create_cmd(id, manifest_src)
    saver.file_create_command(kata_manifest_filename(id), manifest_src)
  end

  def kata_events_create_cmd(id, event0_src)
    saver.file_create_command(kata_events_filename(id), event0_src)
  end

  def kata_event_create_cmd(id, index, event_src)
    saver.file_create_command(kata_event_filename(id,index), event_src)
  end

  #- - - - - - - - - - - - - - - - - -
  # filenames

  def group_manifest_filename(id)
    group_id_path(id, 'manifest.json')
  end

  def group_katas_filename(id)
    group_id_path(id, 'katas.txt')
  end

  def kata_manifest_filename(id)
    kata_id_path(id, 'manifest.json')
  end

  def kata_events_filename(id)
    kata_id_path(id, 'events.json')
  end

  def kata_event_filename(id, index)
    kata_id_path(id, "#{index}.event.json")
  end

  include IdPather # group_id_path, kata_id_path

  #- - - - - - - - - - - - - - - - - -

  def set_version(manifest)
    manifest['version'] = 1
  end

  def set_time_stamp(manifest)
    manifest['created'] = time.now
  end

  def pretty_json(obj)
    JSON.pretty_generate(obj)
  end

  #- - - - - - - - - - - - - - - - - -

  def pull_image_onto_nodes(id, image_name)
    # puller is deployed as a kubernetes daemonSet which
    # means you cannot make http requests to individual pullers.
    # So instead, send the request many times (it is asynchronous),
    # and rely on one request reaching each node. If a node is missed
    # it simply means the image will get pulled onto the node on the
    # first run_cyber_dojo_sh() call, and at the browser, the [test]
    # will result in an hour-glass icon.
    16.times { puller.pull_image(id, image_name) }
  end

  #- - - - - - - - - - - - - - - - - -

  def dependent_services
    @dependent_services ||= [
      custom_start_points,
      exercises_start_points,
      languages_start_points,
      puller,
      saver
    ]
  end

  def custom_start_points
    @externals.custom_start_points
  end

  def exercises_start_points
    @externals.exercises_start_points
  end

  def languages_start_points
    @externals.languages_start_points
  end

  def puller
    @externals.puller
  end

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end
