# frozen_string_literal: true

class Probe # k8s/curl probing + identity

  def initialize(externals)
    @externals = externals
  end

  def alive?
    true
  end

  def ready?
    dependent_services.all?(&:ready?)
  end

  def sha
    ENV['SHA']
  end

  private

  def dependent_services
    [
      @externals.custom_start_points,
      @externals.exercises_start_points,
      @externals.languages_start_points,
      @externals.puller,
      @externals.runner,
      @externals.saver
    ]
  end

end
