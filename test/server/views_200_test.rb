# frozen_string_literal: true
require_relative 'creator_test_base'
require 'cgi'

class Views200Test < CreatorTestBase

  def self.id58_prefix
    :a49
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  def id58_setup
    @group_id = 'chy6BJ'
    @kata_id = '5rTJv5'
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AB0: %w( GET /creator/home 200 ) do
    assert_get_200_html('/creator/home')
  end

  qtest AB1: %w( GET /creator/group 200 ) do
    assert_get_200_html('/creator/group')
  end

  qtest AB2: %w( GET /creator/single 200 ) do
    assert_get_200_html('/creator/single')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AA0: %w( GET /creator/choose_problem 200 ) do
    assert_get_200_html('/creator/choose_problem?type=group')
    assert_get_200_html('/creator/choose_problem?type=single')
  end

  qtest AA1: %w( GET /creator/choose_custom_problem 200 ) do
    assert_get_200_html('/creator/choose_custom_problem?type=group')
    assert_get_200_html('/creator/choose_custom_problem?type=single')
  end

  qtest AA2: %w( GET /creator/choose_ltf 200 ) do
    assert_get_200_html('/creator/choose_ltf?type=group&exercise_name=Anagrams')
    assert_get_200_html('/creator/choose_ltf?type=single&exercise_name=Anagrams')
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - -

  qtest AC1: %w( GET /creator/confirm 200 ) do
    language_name = CGI::escape('D, unittest')
    params = "type=group&exercise_name=Tennis&language_name=#{language_name}"
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
