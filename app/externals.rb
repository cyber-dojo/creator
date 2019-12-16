# frozen_string_literal: true

require_relative 'services/saver'
require_relative 'services/time'
require 'net/http'

class Externals

  def saver
    @saver ||= Saver.new(http)
  end

  def http
    @http ||= Net::HTTP
  end

  def time
    @time ||= Time.new
  end

  def random
    @random ||= Random
  end

end
