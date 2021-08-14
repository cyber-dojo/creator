require_relative 'external_creator'
require_relative 'external_custom_start_points'
require_relative 'external_http'
require_relative 'external_saver'

class Externals

  def creator
    @creator ||= ExternalCreator.new(creator_http)
  end
  def creator_http
    @creator_http ||= ExternalHttp.new
  end

  def custom_start_points
    @custom ||= ExternalCustomStartPoints.new(custom_start_points_http)
  end
  def custom_start_points_http
    @custom_start_points_http ||= ExternalHttp.new
  end

  def saver
    @saver ||= ExternalSaver.new(saver_http)
  end
  def saver_http
    @saver_http ||= ExternalHttp.new
  end

end
