# frozen_string_literal: true
require_relative 'creator_test_base'

class ExerciseChooseTest < CreatorTestBase

  def self.id58_prefix
    'b73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/group_exercise_choose
  |offers all display_names
  |ready to choose a language
  |when exercises_start_points is online
  ) do
    get '/group_exercise_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('our'), html
    refute heading(html).include?('my'), html
    exercises_start_points.display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '19w', %w(
  |GET/kata_exercise_choose
  |offers all display_names
  |ready to choose a language
  |when exercises_start_points is online
  ) do
    get '/kata_exercise_choose'
    assert status?(200), status
    html = last_response.body
    assert heading(html).include?('my'), html
    refute heading(html).include?('our'), html
    exercises_start_points.display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  private

  def heading(html)
    # (.*?) for non-greedy match
    # /m for . matching newlines
    html.match(/<div id="heading">(.*?)<\/div>/m)[1]
  end

  def div_for(display_name)
    # eg cater for "C++ Countdown, Round 1"
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
