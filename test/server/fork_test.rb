# frozen_string_literal: true
require_relative 'creator_test_base'
require 'json'

class ForkingTest < CreatorTestBase #!

  def self.id58_prefix
    :d5T
  end

  # - - - - - - - - - - - - - - - - -
  # Bad arguments
  # - - - - - - - - - - - - - - - - -

  qtest ds8: %w( bad id causes fork failure ) do
    id = 'ssdd66'
    post "/fork_individual?id=#{id}&index=2", '{}', JSON_REQUEST_HEADER

    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    json = JSON.parse(last_response.body)
    assert json['forked'].is_a?(FalseClass)
  end

  # - - - - - - - - - - - - - - - - -
  # JSON response
  # - - - - - - - - - - - - - - - - -

  qtest x9A: %w(
  |JSON: fork a new individual exercise
  |from a kata in a group (dolphin)
  |returns forked-kata-id in json response
  ) do
    @id = 'k5ZTk0'
    @index = 2
    post "/fork_individual?id=#{@id}&index=#{@index}", '{}', JSON_REQUEST_HEADER
    assert_JSON_forked_individual
  end

  qtest x9B: %w(
  |JSON: fork a new group exercise
  |from a kata in a group (dolphin)
  |returns forked-group-id in json response
  ) do
    @id = 'k5ZTk0'
    @index = 2
    post "/fork_group?id=#{@id}&index=#{@index}", '{}', JSON_REQUEST_HEADER
    assert_JSON_forked_group
  end

  # - - - - - - - - - - - - - - - - -
  # HTML response
  # - - - - - - - - - - - - - - - - -

  qtest q9A: %w(
  |HTML: fork a new individual exercise
  |redirects to URL with forked-kata-id as arg
  ) do
    @id = '5U2J18'
    @index = 2
    post "/fork_individual?id=#{@id}&index=#{@index}", '{}', HTML_REQUEST_HEADER
    assert_HTML_forked_individual
  end

  qtest q9B: %w(
  |HTML: fork a new group exercise
  |redirects to URL with forked-group-id as arg
  ) do
    @id = '5U2J18'
    @index = 2
    post "/fork_group?id=#{@id}&index=#{@index}", '{}', HTML_REQUEST_HEADER
    assert_HTML_forked_group
  end

  # - - - - - - - - - - - - - - - - -
  # fork_....(id, index=-1)
  # - - - - - - - - - - - - - - - - -

  qtest B4D: %w(
  |JSON: fork a new group exercise with index=-1 uses last index
  |returns forked-group-id in json response
  ) do
    @id = 'k5ZTk0'
    @index = 3
    post "/fork_group?id=#{@id}&index=-1", '{}', JSON_REQUEST_HEADER
    assert_JSON_forked_group
  end

  qtest B5D: %w(
  |JSON: fork a new kata exercise with index=-1 uses last index
  |returns forked-kata-id in json response
  ) do
    @id = 'k5ZTk0'
    @index = 3
    post "/fork_individual?id=#{@id}&index=-1", '{}', JSON_REQUEST_HEADER
    assert_JSON_forked_individual
  end

  qtest B6D: %w(
  |HTML: fork a new group exercise with index=-1 uses last index
  |redirects to URL with forked-group-id as arg
  ) do
    @id = 'k5ZTk0'
    @index = 3
    post "/fork_group?id=#{@id}&index=-1", '{}', HTML_REQUEST_HEADER
    assert_HTML_forked_group
  end

  qtest B7D: %w(
  |HTML: fork a new individual exercise with index=-1 uses last index
  |redirects to URL with forked-kata-id as arg
  ) do
    @id = 'k5ZTk0'
    @index = 3
    post "/fork_individual?id=#{@id}&index=-1", '{}', HTML_REQUEST_HEADER
    assert_HTML_forked_individual
  end

  private

  ENTER_REGEX = /^(.*)\/creator\/enter\?id=([0-9A-Za-z]*)$/

  JSON_REQUEST_HEADER = {
    'HTTP_ACCEPT' => 'application/json'
  }

  HTML_REQUEST_HEADER = {
    'HTTP_ACCEPT' => 'text/html;charset=utf-8'
  }

  # - - - - - - - - - - - - - - - - -

  def assert_HTML_forked_group
    src_manifest,src_event,new_id = *forked_manifest_HTML
    assert group_exists?(new_id)
    new_manifest = group_manifest(new_id)
    assert_manifest_match(src_manifest, src_event, new_manifest)
  end

  def assert_HTML_forked_individual
    src_manifest,src_event,new_id = *forked_manifest_HTML
    assert kata_exists?(new_id)
    new_manifest = kata_manifest(new_id)
    assert_manifest_match(src_manifest, src_event, new_manifest)
  end

  def forked_manifest_HTML
    assert_equal 302, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response.headers['Content-Type'], :response_is_html
    assert m = ENTER_REGEX.match(last_response.location)
    [ kata_manifest(@id), kata_event(@id,@index), m[2] ]
  end

  # - - - - - - - - - - - - - - - - -

  def assert_JSON_forked_group
    src_manifest,src_event,new_id = *forked_manifest_JSON
    assert group_exists?(new_id)
    new_manifest = group_manifest(new_id)
    assert_manifest_match(src_manifest, src_event, new_manifest)
  end

  def assert_JSON_forked_individual
    src_manifest,src_event,new_id = *forked_manifest_JSON
    assert kata_exists?(new_id)
    new_manifest = kata_manifest(new_id)
    assert_manifest_match(src_manifest, src_event, new_manifest)
  end

  def forked_manifest_JSON
    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    json = JSON.parse(last_response.body)
    assert json['forked'].is_a?(TrueClass)
    [ kata_manifest(@id), kata_event(@id,@index), json['id'] ]
  end

  # - - - - - - - - - - - - - - - - -

  def assert_manifest_match(src_manifest, src_event, new_manifest)
    ['image_name','tab_size','display_name','filename_extension'].each do |key|
      assert_equal src_manifest[key], new_manifest[key], key
    end
    assert_equal src_event['files'], new_manifest['visible_files']
  end

end
