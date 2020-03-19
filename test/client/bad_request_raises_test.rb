# frozen_string_literal: true
require_relative 'creator_test_base'

class BadRequestTest < CreatorTestBase

  def self.id58_prefix
    '16F'
  end

  # - - - - - - - - - - - - - - - - -

  test '45e',
  %w( group_create_custom([unknown_display_name]) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.group_create_custom(['xxx'])
    }
  end

  test '45a',
  %w( kata_create_custom(unknown_display_name) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      creator.kata_create_custom('xxx')
    }
  end

  # - - - - - - - - - - - - - - - - -

  test '15S',
  %w( group_create(unknown_exercise_name) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.group_create('xxx',[any_languages_start_points_display_name])
    end
  end

  test '15T',
  %w( group_create(unknown_language_name) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.group_create(any_exercises_start_points_display_name,['xxx'])
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '25K',
  %w( kata_create(unknown_exercise_name) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.kata_create('xxx', [any_languages_start_points_display_name])
    end
  end

  test '25L',
  %w( kata_create(unknown_language_name) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) do
      creator.kata_create(any_exercises_start_points_display_name, ['xxx'])
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '75b',
  %w( saver.exists?(key=nil) raises ) do
    _error = assert_raises(HttpJsonHash::ServiceError) {
      saver.exists?(nil)
    }
  end

end
