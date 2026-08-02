$stdout.sync = true
$stderr.sync = true

if ENV['CYBER_DOJO_PROMETHEUS'] == 'true'
  require 'prometheus/middleware/collector'
  require 'prometheus/middleware/exporter'
  use Prometheus::Middleware::Collector
  use Prometheus::Middleware::Exporter
end

require_relative '../creator/app'
require_relative '../creator/externals'
externals = CreatorApp::Externals.new
run CreatorApp::App.new(externals)
