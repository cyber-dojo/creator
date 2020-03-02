# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteCreate500BadRequestTest < CreatorTestBase

  def self.id58_prefix
    :f27
  end

  # - - - - - - - - - - - - - - - - -

  qtest Kp1: %w(
  |POST /create_custom_group
  |with JSON-Hash in its request.body
  |containing an unknown arg
  |its a 500 error
  |and...
  ) do
    assert_json_post_500(
      path = 'create_custom_group',
      args = '{"unknown":42}'
    ) do |jr|
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest Kp3: %w(
  |POST /create_custom_group
  |with non-JSON in its request.body
  |is a 500 error
  |and...
  ) do
    assert_json_post_500(
      path = 'create_custom_group',
      args = 'not-json'
    ) do |jr|
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest Kp4: %w(
  |POST /create_custom_group
  |with non-JSON-Hash in its request.body
  |is a 500 error
  |and...
  ) do
    assert_json_post_500(
      path = 'create_custom_group',
      args = 42
    ) do |jr|
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest aX3: %w(
  |POST /create_custom_group?display_name=INVALID
  |is a 500 error
  |and...
  ) do
    _stdout,_stderr = capture_stdout_stderr {
      post '/create_custom_group', data={ display_name:'invalid' }
    }
    assert_status(500)
    #...
  end

  # - - - - - - - - - - - - - - - - -

  qtest aX4: %w(
  |POST /create_custom_group
  |with a display_name in its request.body
  |that does not exist in custom-chooser
  |is a 500 error
  |and...
  ) do
    assert_json_post_500(
      path = 'create_custom_group',
      args = { display_name:'invalid' }
    ) do |jr|
      #...
    end
  end

  # - - - - - - - - - - - - - - - - -

=begin # it seems for a GET, the body is moved to params!?

  qtest Kp2: %w(
  |GET /sha
  |with non-JSON in Request.body
  |its a 500 error
  |and...
  ) do
    unknown_arg = 'xyz'
    get '/sha', unknown_arg, JSON_REQUEST_HEADERS
    assert_status(500) # FAILS, ==200
    # params:{"xyz"=>nil}:
    # body::
  end

=end

end
