# frozen_string_literal: true
require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'saver_asserter'
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
    services = []
    services << custom_start_points
    services << exercises_start_points
    services << languages_start_points
    services << saver
    services.all?(&:ready?)
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
    saver_asserter.batch(
      group_manifest_write_cmd(id, pretty_json(manifest)),
      group_katas_write_cmd(id, '')
    )
    id
  end

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
    saver_asserter.batch(
      kata_manifest_write_cmd(id, pretty_json(manifest)),
      kata_events_write_cmd(id, pretty_json(event_summary)),
      kata_event_write_cmd(id, 0, pretty_json(event0.merge(event_summary)))
    )
    id
  end

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

  def set_version(manifest)
    manifest['version'] = 1
  end

  def set_time_stamp(manifest)
    manifest['created'] = time.now
  end

  def pretty_json(obj)
    JSON.pretty_generate(obj)
  end

  include IdPather # group_id_path, kata_id_path

  #- - - - - - - - - - - - - - - - - -

  def saver_asserter
    SaverAsserter.new(saver)
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

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end
