# frozen_string_literal: true

require_relative 'id_generator'
require_relative 'id_pather'
require_relative 'saver_asserter'

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
    saver_asserter.batch(
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
    saver_asserter.batch(
      kata_manifest_write_cmd(id, json_plain(manifest)),
      kata_events_write_cmd(id, json_plain(event_summary)),
      kata_event_write_cmd(id, 0, json_plain(event0.merge(event_summary)))
    )
    id
  end

  private

  include IdPather # group_id_path, kata_id_path

  #- - - - - - - - - - - - - - - - - -

  def set_version(manifest)
    manifest['version'] = 1
  end

  #- - - - - - - - - - - - - - - - - -

  def time_stamp(manifest)
    manifest['created'] = time.now
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

  #- - - - - - - - - - - - - - - - - -

  def saver_asserter
    SaverAsserter.new(saver)
  end

  def saver
    @externals.saver
  end

  def time
    @externals.time
  end

end
