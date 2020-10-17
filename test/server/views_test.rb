# frozen_string_literal: true
require_relative 'creator_test_base'

class ViewsTest < CreatorTestBase

  def self.id58_prefix
    :a49
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id58_setup
    @group_id = 'chy6BJ'
    @kata_id = '5rTJv5'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AC0: %w( GET /creator/home 200 ) do
    assert_get_200_html('/creator/home')
  end

  qtest AC1: %w( GET /creator/confirm 200 ) do
    params = "type=group&exercise_name=Tennis&language_name=D%2C%20unittest"
    assert_get_200_html("/creator/confirm?#{params}")
  end

  qtest AC2: %w( GET /creator/enter 200 ) do
    assert_get_200_html("/creator/enter?id=#{@group_id}")
    assert_get_200_html("/creator/enter?id=#{@kata_id}")
    assert_get_200_html("/creator/enter")
  end

  qtest AC3: %w( GET /creator/avatar 200 ) do
    assert_get_200_html("/creator/avatar?id=#{@kata_id}")
  end

  qtest AC4: %w( GET /creator/reenter 200 ) do
    assert_get_200_html("/creator/reenter?id=#{@group_id}")
  end

  qtest AC5: %w( GET /creator/full 200 ) do
    assert_get_200_html("/creator/full?id=#{@group_id}")
  end

end
