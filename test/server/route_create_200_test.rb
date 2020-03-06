# frozen_string_literal: true
require_relative 'creator_test_base'
require_src 'id_generator'

class RouteCreate200Test < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  def id58_setup
    @display_name = any_custom_start_point_display_name
  end

  attr_reader :display_name

  # - - - - - - - - - - - - - - - - -
  # old API (deprecated)
  # - - - - - - - - - - - - - - - - -

  qtest De1: %w(
  |POST /deprecated_group_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_json_post_200(
      path = 'deprecated_group_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal [path,'id'], jrb.keys.sort, :keys
      assert_group_exists(jrb['id'], display_name)
      assert_equal jrb[path], jrb['id']
    end
  end

  qtest De2: %w(
  |POST /deprecated_kata_create_custom
  |with a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
  |and for backwards compatibility
  |it also returns the id against the :id key
  ) do
    assert_json_post_200(
      path = 'deprecated_kata_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal [path,'id'], jrb.keys.sort, :keys
      assert_kata_exists(jrb['id'], display_name)
      assert_equal jrb[path], jrb['id']
    end
  end

  # - - - - - - - - - - - - - - - - -
  # new API
  # - - - - - - - - - - - - - - - - -

  qtest q31: %w(
  |POST /group_create_custom
  |with display_names[] holding a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    assert_json_post_200(
      path = 'group_create_custom',
      args = { display_names:[display_name] }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_group_exists(jrb[path], display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest q32: %w(
  |POST /kata_create_custom
  |with display_names[] holding a single display_name
  |that exists in custom-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the display_name
  ) do
    assert_json_post_200(
      path = 'kata_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_kata_exists(jrb[path], display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest q33: %w(
  |POST /kata_create_custom
  |can use RandomStub to control kata id
  ) do
    id = id58
    externals.instance_exec { @random = RandomStub.new(id) }
    assert_json_post_200(
      path = 'kata_create_custom',
      args = { display_name:display_name }
    ) do |jrb|
      assert_equal id, jrb[path], jrb
      assert_kata_exists(id, display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest q34: %w(
  |POST /group_create_custom
  |can use RandomStub to control group id
  ) do
    id = id58
    externals.instance_exec { @random = RandomStub.new(id) }
    assert_json_post_200(
      path = 'group_create_custom',
      args = { display_names:[display_name] }
    ) do |jrb|
      assert_equal id, jrb[path], jrb
      assert_group_exists(id, display_name)
    end
  end

  private

  def assert_group_exists(id, display_name)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def assert_kata_exists(id, display_name)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
  end

  def group_manifest(id)
    JSON::parse!(saver.read("#{group_id_path(id)}/manifest.json"))
  end

  def kata_manifest(id)
    JSON::parse!(saver.read("#{kata_id_path(id)}/manifest.json"))
  end

  # - - - - - - - - - - - - - - - - -

  class RandomStub
    def initialize(id)
      @id = id
      @index = 0
    end
    def sample(_size)
      ch = IdGenerator::ALPHABET.index(@id[@index])
      @index += 1
      ch
    end
  end

end
