# frozen_string_literal: true
require_relative 'external_custom_start_points'
require_relative 'external_http'
require_relative 'external_saver'
require_relative 'external_time'

class Externals

  def custom_start_points
    @custom_start_points ||= ExternalCustomStartPoints.new(http)
  end

  def http
    @http ||= ExternalHttp.new
  end

  def random
    @random ||= Random
  end

  def saver
    @saver ||= ExternalSaver.new(http)
  end

  def time
    @time ||= ExternalTime.new
  end

end
