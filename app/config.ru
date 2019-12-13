$stdout.sync = true
$stderr.sync = true

require 'rack'

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative 'externals'
require_relative 'creator'
require_relative 'rack_dispatcher'
externals = Externals.new
creator = Creator.new(externals)
dispatcher = RackDispatcher.new(creator, Rack::Request)
run dispatcher
