# frozen_string_literal: true

require_relative 'services/saver'
require_relative 'services/time'
require_relative 'http_adapter'

class Externals

  def saver
    @saver ||= Saver.new(http)
  end

  def http
    @http ||= HttpAdapter.new
  end

  def time
    @time ||= Time.new
  end

  def random
    @random ||= Random
  end

end
