require_relative 'creator_test_base'

class Views200Test < CreatorTestBase

  def self.id58_prefix
    :a49
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AB0: %w( GET /creator/home 200 ) do
    assert_get_200_html('/creator/home')
  end

  qtest AA0: %w( GET /creator/choose_problem 200 ) do
    assert_get_200_html('/creator/choose_problem')
  end

  qtest AA1: %w( GET /creator/choose_custom_problem 200 ) do
    assert_get_200_html('/creator/choose_custom_problem')
  end

  qtest AA2: %w( GET /creator/choose_ltf 200 ) do
    exercise_name = exercises_start_points.names.sample    
    assert_get_200_html('/creator/choose_ltf', exercise_name:exercise_name)
  end

  qtest AA3: %w( GET /creator/choose_type 200 ) do
    exercise_name = exercises_start_points.names.sample
    language_name = languages_start_points.names.sample
    assert_get_200_html('/creator/choose_type', exercise_name:exercise_name, language_name:language_name)
    assert_get_200_html('/creator/choose_type', exercise_name:exercise_name, language_name:language_name)
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AC2: %w( GET /creator/enter 200 ) do
    assert_get_200_html('/creator/enter', id:group_id)
    assert_get_200_html('/creator/enter', id:kata_id)
    assert_get_200_html('/creator/enter')
  end

  qtest AC3: %w( GET /creator/avatar 200 ) do
    assert_get_200_html('/creator/avatar', id:kata_id)
  end

  qtest AC4: %w( GET /creator/reenter 200 ) do
    assert_get_200_html('/creator/reenter', id:group_id)
  end

  qtest AC5: %w( GET /creator/full 200 ) do
    assert_get_200_html('/creator/full', id:group_id)
  end

  private

  def group_id
    'chy6BJ'
  end

  def kata_id
    '5rTJv5'
  end

end
