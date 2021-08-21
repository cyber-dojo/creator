require_relative 'creator_test_base'

class ChooseProblemTest < CreatorTestBase

  def self.id58_prefix
    :B73
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18w: %w(
  |GET/choose_problem
  |offers all exercise_start_point names
  ) do
    get '/choose_problem'
    assert status?(200), status
    html = last_response.body
    exercises_start_points.names.each do |name|
      assert html =~ display_name_div(name), name
    end
  end

end
