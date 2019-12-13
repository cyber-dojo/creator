# frozen_string_literal: true

require_relative 'id_generator'
require_relative 'id_pather'
require 'json'

class Creator

  def initialize(externals)
    @externals = externals
  end

  def sha
    ENV['SHA']
  end

  def alive?
    true
  end

  def ready?
    saver.ready?
  end

  # - - - - - - - - - - - - - -

  def create_group(manifest)
    set_version(manifest)
    time_stamp(manifest)
    id = manifest['id'] = IdGenerator.new(@externals).group_id
    saver_assert_batch(
      group_manifest_write_cmd(id, json_plain(manifest)),
      group_katas_write_cmd(id, '')
    )
    id
  end

  # - - - - - - - - - - - - - -

  def create_kata(manifest)
    set_version(manifest)
    time_stamp(manifest)
    id = manifest['id'] = IdGenerator.new(@externals).kata_id
    event_summary = {
      'index' => 0,
      'time' => manifest['created'],
      'event' => 'created'
    }
    event0 = {
      'files' => manifest['visible_files']
    }
    saver_assert_batch(
      kata_manifest_write_cmd(id, json_plain(manifest)),
      kata_events_write_cmd(id, json_plain(event_summary)),
      kata_event_write_cmd(id, 0, json_plain(event0.merge(event_summary)))
    )
    id
  end

  private

  def set_version(manifest)
    manifest['version'] = 1
  end

  #- - - - - - - - - - - - - - - - - -

  def time_stamp(manifest)
    manifest['created'] = time.now
  end

  def time
    @externals.time
  end

  #- - - - - - - - - - - - - - - - - -

  def saver_assert_batch(*commands)
    results = saver.batch(commands)
    if results.any?(false)
      message = results.zip(commands).map do |result,(name,arg0)|
        saver_assert_info(name, arg0, result)
      end
      raise SaverService::Error, json_plain(message)
    end
    results
  end

  def saver_assert_info(name, arg0, result)
    { 'name' => name, 'arg[0]' => arg0, 'result' => result }
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

  include IdPather # group_id_path, kata_id_path

  def saver
    @externals.saver
  end

  #- - - - - - - - - - - - - - - - - -

  def json_plain(obj)
    JSON.generate(obj)
  end

end
