$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative 'code/externals'
require_relative 'code/creator'
require_relative 'code/rack_dispatcher'
require 'rack'

externals = Externals.new
creator = Creator.new(externals)
dispatcher = RackDispatcher.new(creator, Rack::Request)
run dispatcher
