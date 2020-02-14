# frozen_string_literal: true
require_relative 'http_adapter'
require_relative 'services/creator'
require_relative 'services/custom_start_points'
require_relative 'services/saver'

class Externals

  def http
    @http ||= HttpAdapter.new
  end

  def creator
    @creator ||= Creator.new(http)
  end

  def custom
    @custom ||= CustomStartPoints.new(http)
  end

  def saver
    @saver ||= Saver.new(http)
  end

end
