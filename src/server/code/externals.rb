# frozen_string_literal: true
require_relative 'http_adapter'
require_relative 'services/saver'
require_relative 'services/time'

class Externals

  def http
    @http ||= HttpAdapter.new
  end

  def saver
    @saver ||= Saver.new(http)
  end

  def time
    @time ||= Time.new
  end

  def random
    @random ||= Random
  end

end
