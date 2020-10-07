# frozen_string_literal: true
require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.id58_prefix
    :a87
  end

  # - - - - - - - - - - - - - - - - -

  qtest d15: %w( its alive ) do
    assert true?(externals.creator.alive?)
  end

  qtest d16: %w( visit routes ) do
    visit('/creator/choose_problem?type=group')
    assert page.html.include?('<title>cyber-dojo</title>'), :failed_to_render
  end

end
