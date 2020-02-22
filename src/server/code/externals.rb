# frozen_string_literal: true
require_relative 'external_custom_start_points'
require_relative 'external_http'
require_relative 'external_random'
require_relative 'external_saver'
require_relative 'external_time'

class Externals

  # - - - - - - - - - - - - - - - - - - -
  # inter-process
  
  def custom_start_points
    @custom_start_points ||= ExternalCustomStartPoints.new(http)
  end

  def saver
    @saver ||= ExternalSaver.new(http)
  end

  def http
    @http ||= ExternalHttp.new
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
