require_relative 'creator_test_base'

class RouteEnterTest < CreatorTestBase
  def self.id58_prefix
    :d4P
  end

  # - - - - - - - - - - - - - - - - -

  qtest j3K: %w[
    |POST /enter.json
    |for a version=2 group
    |has status 200
    |returns JSON with id,group_index and route to avatar page
  ] do
    json_post_create_group({
                             language_name: languages_start_points.names.sample,
                             exercise_name: exercises_start_points.names.sample
                           }) do |manifest|
      group_id = manifest['id']
      assert_post_200_json('enter.json', { id: group_id }) do |response|
        # eg response == {"route"=>"/creator/avatar?id=TEbR8E", "id"=>"TEbR8E", "group_index" => 51}
        assert response.key?('route'), response.keys
        assert %r{/creator/avatar\?id=(?<kata_id>.*)} =~ response['route'], response['route']
        assert response.key?('id'), response.keys
        assert_equal kata_id, response['id'], :kata_id
        assert kata_exists?(kata_id), "kata_exists?(#{kata_id})"
        assert response.key?('group_index'), response.keys
        group_index = response['group_index']
        assert group_index >= 0 && group_index < 64
      end
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest x23: %w[
    |POST /enter.json
    |for a version=0 group
    |has status 200
    |returns JSON with id,group_index and route to avatar page
  ] do
    assert_post_200_json('enter.json', { id: 'chy6BJ' }) do |response|
      # eg response == {"route"=>"/creator/avatar?id=TEbR8E", "id"=>"TEbR8E", "group_index" => 51}
      assert response.key?('route'), response.keys
      assert %r{/creator/avatar\?id=(?<kata_id>.*)} =~ response['route'], response['route']
      assert response.key?('id'), response.keys
      assert_equal kata_id, response['id']
      assert kata_exists?(kata_id), "kata_exists?(#{kata_id})"
      assert response.key?('group_index'), response.keys
      group_index = response['group_index']
      assert group_index >= 0 && group_index < 64
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest x24: %w[
    |POST /enter.json
    |for a version=0 group
    |has status 200
    |returns JSON with route to full page
    |when group is full
  ] do
    path = 'enter.json'
    # Use pre-created full group
    # See test/data/create_full_kata.sh
    # See sh/copy_in_saver_test_data.sh
    data = { id: 'FD6ryx' }
    assert_post_200_json(path, data) do |response|
      # eg response == {"route"=>"/creator/full?id=FxWwrr"}
      assert response.key?('route'), response.keys
      assert %r{/creator/full\?id=(?<kata_id>.*)} =~ response['route'], response['route']
      assert_equal 'FD6ryx', kata_id, :kata_id
    end
  end

  private

  def json_post_create_group(args)
    args[:type] = 'group'
    json_post '/create.json', args
    id = json_response['id']
    assert group_exists?(id), "id:#{id}:" # eg "xCSKgZ"
    yield group_manifest(id)
  end
end
