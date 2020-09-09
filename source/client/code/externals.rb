# frozen_string_literal: true
require_relative 'external_creator'
require_relative 'external_custom_start_points'
require_relative 'external_http'
require_relative 'external_model'

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

  def model
    @model ||= ExternalModel.new(model_http)
  end
  def model_http
    @model_http ||= ExternalHttp.new
  end

end
