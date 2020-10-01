# frozen_string_literal: true
require_relative 'creator_test_base'

class ChooseProblemTest < CreatorTestBase

  def self.id58_prefix
    'B73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/choose_problem
  |offers all exercise_start_point display_names
  ) do
    get '/choose_problem'
    assert status?(200), status
    html = last_response.body
    exercises_start_points.display_names.each do |exercise_name|
      assert html =~ div_for(exercise_name), exercise_name
    end
  end

  private

  def div_for(display_name)
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
