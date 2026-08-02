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
app = CreatorApp::App.new(externals)

# Mounted at both prefixes for the cutover. nginx currently rewrites
# /creator/... down to /..., which the / mount serves exactly as before; once
# that rewrite goes, the intact path arrives and the /creator mount serves it.
# The / mount is deleted last, so nginx and the app never release together.
run Rack::URLMap.new('/' => app, '/creator' => app)
