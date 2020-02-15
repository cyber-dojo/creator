# frozen_string_literal: true
require_relative 'external_http'
require_relative 'external_saver'
require_relative 'external_time'

class Externals

  def http
    @http ||= ExternalHttp.new
  end

  def saver
    @saver ||= ExternalSaver.new(http)
  end

  def time
    @time ||= ExternalTime.new
  end

  def random
    @random ||= Random
  end

end
