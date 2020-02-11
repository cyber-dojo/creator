$stdout.sync = true
$stderr.sync = true

unless ENV['NO_PROMETHEUS']
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

def require_src(name)
  require_relative "src/#{name}"
end

require_src 'externals'
require_src 'creator'
require_src 'rack_dispatcher'
require 'rack'

externals = Externals.new
creator = Creator.new(externals)
dispatcher = RackDispatcher.new(creator, Rack::Request)
run dispatcher
