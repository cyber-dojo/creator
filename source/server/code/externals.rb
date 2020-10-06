# frozen_string_literal: true
require_relative 'external_custom_start_points'
require_relative 'external_exercises_start_points'
require_relative 'external_languages_start_points'
require_relative 'external_http'
require_relative 'external_avatars'
require_relative 'external_model'
require_relative 'external_runner'

class Externals

  def custom_start_points
    @custom_start_points ||= ExternalCustomStartPoints.new(custom_start_points_http)
  end
  def custom_start_points_http
    @custom_start_points_http ||= ExternalHttp.new
  end

  def exercises_start_points
    @exercises_start_points ||= ExternalExercisesStartPoints.new(exercises_start_points_http)
  end
  def exercises_start_points_http
    @exercises_start_points_http ||= ExternalHttp.new
  end

  def languages_start_points
    @languages_start_points ||= ExternalLanguagesStartPoints.new(languages_start_points_http)
  end
  def languages_start_points_http
    @languages_start_points_http ||= ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def avatars
    @avatars ||= ExternalAvatars.new(avatars_http)
  end
  def avatars_http
    @avatars_http ||= ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def model
    @model ||= ExternalModel.new(model_http)
  end
  def model_http
    @model_http ||= ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - -

  def runner
    @runner ||= ExternalRunner.new(runner_http)
  end
  def runner_http
    @runner_http ||= ExternalHttp.new
  end

end
