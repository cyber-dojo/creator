# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteEnterTest < CreatorTestBase

  def self.id58_prefix
    :d4P
  end

  # - - - - - - - - - - - - - - - - -

  qtest x23: %w(
  |POST /enter.json
  |has status 200
  |returns JSON with route to avatar
  ) do
    assert_post_200_json('enter.json', {id:'chy6BJ'}) do |response|
      # eg response == {"route"=>"/creator/avatar?id=TEbR8E"}
      assert %r"/creator/avatar\?id=(?<id>.*)" =~ response['route'], response
      assert kata_exists?(id), "kata_exists?(#{id})"
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest x24: %w(
  |POST /enter.json
  |has status 200
  |returns JSON with route to full page
  |when group is full
  ) do
    path = 'enter.json'
    data = {id:'FxWwrr'}
    64.times do
      post path, data.to_json, JSON_REQUEST_HEADERS
    end

    assert_post_200_json(path, data) do |response|
      # eg response == {"route"=>"/creator/full?id=FxWwrr"}
      assert %r"/creator/full\?id=(?<id>.*)" =~ response['route'], response
      assert_equal 'FxWwrr', id
    end
  end

end
