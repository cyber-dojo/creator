require_relative 'creator_test_base'

class View200Test < CreatorTestBase

  def self.id58_prefix
    :a97
  end

  # - - - - - - - - - - - - - - - - -

  qtest d13: %w( home ) do
    visit('/')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
    visit('/creator/home')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d16: %w( choose_problem ) do
    visit('/creator/choose_problem')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d17: %w( choose_custom_problem ) do
    visit('/creator/choose_custom_problem')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d18: %w( choose_ltf ) do
    exercise_name = any_exercises_start_points_display_name
    visit("/creator/choose_ltf?exercise_name=#{exercise_name}")
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d19: %w( choose_type ) do
    exercise_name = any_exercises_start_points_display_name
    language_name = any_languages_start_points_display_name
    visit("/creator/choose_type?exercise_name=#{exercise_name}&language_name=#{language_name}")
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d20: %w( enter ) do
    visit('/creator/enter?id=chy6BJ')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d21: %w( reenter ) do
    visit('/creator/reenter?id=chy6BJ')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d22: %w( full ) do
    visit('/creator/full?id=chy6BJ')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

end
