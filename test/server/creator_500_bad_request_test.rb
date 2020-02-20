# frozen_string_literal: true
require_relative 'creator_test_base'

class Creator500BadRequestTest < CreatorTestBase

  def self.id58_prefix
    :f26
  end

  # - - - - - - - - - - - - - - - - -
  # 500 bad data in request
  # - - - - - - - - - - - - - - - - -

  test 'Kp1', %w(
    POST /create_custom_group,
    with JSON-Hash Request.body containing unknown arg,
    ...
  ) do
    stdout = capture_stdout { |_uncap|
      print("XXX")
      #_uncap.puts("This will appear immediately and not go into _stdout")
      json_post '/create_custom_group', unknown_arg = '{"unknown":42}'
    }
    assert stdout.start_with?("XXX(500)")
    assert_status(500)
  end

  # - - - - - - - - - - - - - - - - -

=begin # it seems for a GET, the body is moved to params!?

  test 'Kp2', %w(
    GET /sha,
    with non-JSON in Request.body,
    ...
  ) do
    unknown_arg = 'xyz'
    get '/sha', unknown_arg, JSON_REQUEST_HEADERS
    assert_status(500) # FAILS, ==200
    # params:{"xyz"=>nil}:
    # body::
  end

=end

  # - - - - - - - - - - - - - - - - -

  test 'Kp3', %w(
    POST /create_custom_group,
    with non-JSON Request.body,
    ...
  ) do
    capture_stdout {
      json_post '/create_custom_group', non_json = 'xyz'
    }
    assert_status(500)
    #...
  end

  # - - - - - - - - - - - - - - - - -

  test 'Kp4', %w(
    POST /create_custom_group,
    with non-JSON-Hash Request.body,
    ...
  ) do
    capture_stdout {
      json_post '/create_custom_group', non_json_hash = 42
    }
    assert_status(500)
    #...
  end

  # - - - - - - - - - - - - - - - - -

  test 'aX3', %w(
    POST /create_custom_group?display_name=INVALID,
    ...
  ) do
    capture_stdout {
      post '/create_custom_group', data={ display_name:'invalid' }
    }
    assert_status(500)
    #...
  end

  # - - - - - - - - - - - - - - - - -

  test 'aX4', %w(
  POST /create_custom_group,
  with an invalid display_name in the JSON-Request body,
  ...
  ) do
    _stdout = capture_stdout {
      json_post '/create_custom_group', data = { display_name:'invalid' }
    }
    assert_status(500)
    #...
  end

end
