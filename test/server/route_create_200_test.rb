# frozen_string_literal: true
require_relative 'creator_test_base'
require_source 'id_generator'

class RouteCreate200Test < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  def id58_setup
    @display_name = any_custom_start_points_display_name
    @exercise_name = any_exercises_start_points_display_name
    @language_name = any_languages_start_points_display_name
  end

  attr_reader :display_name, :exercise_name, :language_name

  # - - - - - - - - - - - - - - - - -
  # new API - custom exercise
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
  # RandomStub
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

  # - - - - - - - - - - - - - - - - -
  # custom-exercise : Future use of display_names[] array
  # - - - - - - - - - - - - - - - - -

  qtest p44: %w(
  |POST /group_create_custom
  |display_names is an Array of Strings for planned feature
  |  where a group can be setup with a small number of display_names
  |  and you choose your individual display_names on joining.
  |options is a Hash of Symbol->Boolean|String
  |  {colour,theme,prediction}
  |  and is also for a planned feature
  |  where the options can be initialized at setup.
  ) do
    options = { colour:'on', theme:'dark', prediction:false }
    assert_json_post_200(
      path = 'group_create_custom',
      args = { display_names:[display_name,'unused'], options:options }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_group_exists(jrb[path], display_name)
    end
  end

  # - - - - - - - - - - - - - - - - -
  # new API - exercise + language
  # - - - - - - - - - - - - - - - - -

  qtest f31: %w(
  |POST /group_create
  |with exercise_name
  |that exists in exercises-start-points
  |with languages_names[] holding a single language_name
  |that exists in languages-start-points
  |has status 200
  |returns the id: of a new group
  |that exists in saver
  |whose manifest matches the exercise_name and language_name
  ) do
    assert_json_post_200(
      path = 'group_create',
      args = { exercise_name:exercise_name, languages_names:[language_name] }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_group_exists(jrb[path], language_name, exercise_name)
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest f32: %w(
  |POST /kata_create
  |with exercise_name
  |that exists in exercises-start-points
  |with languages_name
  |that exists in languages-start-points
  |has status 200
  |returns the id: of a new kata
  |that exists in saver
  |whose manifest matches the exercise_name and language_name
  ) do
    assert_json_post_200(
      path = 'kata_create',
      args = { exercise_name:exercise_name, language_name:language_name }
    ) do |jrb|
      assert_equal [path], jrb.keys.sort, :keys
      assert_kata_exists(jrb[path], language_name, exercise_name)
    end
  end

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
      assert_equal jrb[path], jrb['id'], :id
    end
  end

  # - - - - - - - - - - - - - - - - -

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
      assert_equal jrb[path], jrb['id'], :id
    end
  end

  private

  def assert_group_exists(id, display_name, exercise_name=nil)
    refute_nil id, :id
    assert group_exists?(id), "!group_exists?(#{id})"
    manifest = group_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    if exercise_name.nil?
      refute manifest.has_key?('exercise'), :exercise
    else
      assert_equal exercise_name, manifest['exercise'], :exercise
    end
  end

  def assert_kata_exists(id, display_name, exercise_name=nil)
    refute_nil id, :id
    assert kata_exists?(id), "!kata_exists?(#{id})"
    manifest = kata_manifest(id)
    assert_equal display_name, manifest['display_name'], manifest.keys.sort
    if exercise_name.nil?
      refute manifest.has_key?('exercise'), :exercise
    else
      assert_equal exercise_name, manifest['exercise'], :exercise
    end
  end

  def group_manifest(id)
    command = saver.file_read_command("#{group_id_path(id)}/manifest.json")
    JSON::parse!(saver.run(command))
  end

  def kata_manifest(id)
    command = saver.file_read_command("#{kata_id_path(id)}/manifest.json")
    JSON::parse!(saver.run(command))
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
