# frozen_string_literal: true
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

  qtest d14: %w( group ) do
    visit('/creator/group')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d15: %w( single ) do
    visit('/creator/single')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d16: %w( choose_problem ) do
    visit('/creator/choose_problem?type=group')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d17: %w( choose_custom_problem ) do
    visit('/creator/choose_custom_problem?type=group')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

  qtest d18: %w( choose_ltf ) do
    visit('/creator/choose_ltf?type=group&exercise_name=Diversion')
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
