# frozen_string_literal: true
require_relative 'external_custom_start_points'
require_relative 'external_exercises_start_points'
require_relative 'external_languages_start_points'
require_relative 'external_puller'
require_relative 'external_http'
require_relative 'external_random'
require_relative 'external_runner'
require_relative 'external_saver'
require_relative 'external_time'

class Externals

  # - - - - - - - - - - - - - - - - - - -
  # inter-process

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

  def puller
    @puller ||= ExternalPuller.new(puller_http)
  end
  def puller_http
    @puller_http ||= ExternalHttp.new
  end

  def runner
    @runner ||= ExternalRunner.new(runner_http)
  end
  def runner_http
    @runner_http ||= ExternalHttp.new
  end

  def saver
    @saver ||= ExternalSaver.new(saver_http)
  end
  def saver_http
    @saver_http ||= ExternalHttp.new
  end

  # - - - - - - - - - - - - - - - - - - -
  # intra-process

  def random
    @random ||= ExternalRandom.new
  end

  def time
    @time ||= ExternalTime.new
  end

end
