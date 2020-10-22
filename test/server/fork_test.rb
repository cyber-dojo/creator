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
    id = '5U2J18'
    post "/fork_individual?id=#{id}&index=2", '{}', HTTP_REQUEST_HEADER

    assert_equal 302, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response.headers['Content-Type'], :response_is_html
    assert m = ENTER_REGEX.match(last_response.location)
    forked_id = m[2]
    assert kata_exists?(forked_id)
    assert_equal 1, kata_manifest(forked_id)['version']
    assert_equal kata_manifest(id)['image_name'], kata_manifest(forked_id)['image_name']
  end

  qtest q9B: %w(
  |HTML: fork a new group exercise
  |redirects to URL with forked-group-id as arg
  ) do
    id = '5U2J18'
    post "/fork_group?id=#{id}&index=2", '{}', HTTP_REQUEST_HEADER

    assert_equal 302, last_response.status
    assert_equal 'text/html;charset=utf-8', last_response.headers['Content-Type'], :response_is_html
    assert m = ENTER_REGEX.match(last_response.location)
    forked_id = m[2]
    assert group_exists?(forked_id), :group_exists
    assert_equal 1, group_manifest(forked_id)['version']
    assert_equal kata_manifest(id)['image_name'], group_manifest(forked_id)['image_name']
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

  private

  ENTER_REGEX = /^(.*)\/creator\/enter\?id=([0-9A-Za-z]*)$/

  JSON_REQUEST_HEADER = {
    'HTTP_ACCEPT' => 'application/json'
  }

  HTTP_REQUEST_HEADER = {
    'HTTP_ACCEPT' => 'text/html;charset=utf-8'
  }

  # - - - - - - - - - - - - - - - - -

  def assert_JSON_forked_group
    src_manifest,src_event,new_id = *forked_manifest_JSON
    new_manifest = group_manifest(new_id)
    assert_equal src_manifest['image_name'], new_manifest['image_name']    
    assert_equal src_event['files'], new_manifest['visible_files']
  end

  def assert_JSON_forked_individual
    src_manifest,src_event,new_id = *forked_manifest_JSON
    new_manifest = kata_manifest(new_id)
    assert_equal src_manifest['image_name'], new_manifest['image_name']
    assert_equal src_event['files'], new_manifest['visible_files']
  end

  def forked_manifest_JSON
    assert_equal 200, status, :success
    assert_equal 'application/json', last_response.headers['Content-Type'], :response_is_json
    json = JSON.parse(last_response.body)
    [ kata_manifest(@id), kata_event(@id,@index), json['id'] ]
  end

end
