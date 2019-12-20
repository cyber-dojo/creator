$stdout.sync = true
$stderr.sync = true

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
require 'rack'
run dispatcher
