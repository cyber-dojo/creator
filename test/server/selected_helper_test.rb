require_relative 'creator_test_base'
require_source 'selected_helper'

class LargestTest < CreatorTestBase

  def self.id58_prefix
    '5FF'
  end

  include SelectedHelper

  # - - - - - - - - - - - - - - - - - - -

  test '841', %w(
  select readme.txt content when readme.txt present
  even if not largest content
  ) do
    expected = 'readme.txt'
    visible_files = {
      expected => { 'content' => 'x' * 34 },
      'larger.txt' => { 'content' => 'y'*142 }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '842', %w(
  selected filename when a single visible_file
  ) do
    expected = 'instructions'
    visible_files = {
      expected => { 'content' => 'x' * 34 }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '843', %w(
  select filename containing the word 'test'
  ) do
    expected = 'hiker.test.js' # javascript-jest
    visible_files = {
      expected => { 'content' => 'x'*3 },
      'hiker.js' => { 'content' => 'y'*34 }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '844', %w(
  select filename containing the word 'spec'
  ) do
    expected = 'hiker-spec.js' # javascript-jasmine
    visible_files = {
      expected => { 'content' => 'x'*3 },
      'hiker.js' => { 'content' => 'y'*34 }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '845', %w(
  select filename containing the word 'feature'
  ) do
    expected = 'hiker.feature' # javascript-cucumber
    visible_files = {
      expected => { 'content' => 'x'*3 },
      'hiker.js' => { 'content' => 'y'*34 }
    }
    assert_equal expected, selected(visible_files)
  end

  # - - - - - - - - - - - - - - - - - - -

  test '943', %w(
  select filename with the largest content
  when more than one file and none are called readme.txt
  ) do
    expected = 'larger.txt'
    visible_files = {
      'smaller' => { 'content' => 'y' * 33 },
      expected => { 'content' => 'x' * 34 }
    }
    assert_equal expected, selected(visible_files)
  end

end
