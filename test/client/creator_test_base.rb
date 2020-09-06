# frozen_string_literal: true
require_relative '../id58_test_base'
require_source 'creator'
require_source 'externals'

class CreatorTestBase < Id58TestBase

  def initialize(arg)
    super(arg)
  end

  def externals
    @externals ||= Externals.new
  end

  def creator
    Creator.new(externals)
  end

  # - - - - - - - - - - - - - - - - - - -

  def group_exists?(id)
    model.group_exists?(id)
  end

  def group_manifest(id)
    model.group_manifest(id)
  end

  def kata_exists?(id)
    model.kata_exists?(id)
  end

  def kata_manifest(id)
    model.kata_manifest(id)
  end

  def model
    externals.model
  end

  # - - - - - - - - - - - - - - - - - - -

  def any_custom_start_points_display_name
    custom_start_points.display_names.sample
  end

  def any_exercises_start_points_display_name
    exercises_start_points.display_names.sample
  end

  def any_languages_start_points_display_name
    languages_start_points.display_names.sample
  end

  # - - - - - - - - - - - - - - - - - - -

  def custom_start_points
    externals.custom_start_points
  end

  def exercises_start_points
    externals.exercises_start_points
  end

  def languages_start_points
    externals.languages_start_points
  end

  # - - - - - - - - - - - - - - - - - - -

  def true?(b)
    b.is_a?(TrueClass)
  end

  def false?(b)
    b.is_a?(FalseClass)
  end

end
