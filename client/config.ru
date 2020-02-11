$stdout.sync = true
$stderr.sync = true

def require_src(name)
  require_relative "src/#{name}"
end

require_src 'externals'
require_src 'rack_dispatcher'
require 'rack'

externals = Externals.new
creator = externals.creator
dispatcher = RackDispatcher.new(creator, Rack::Request)
run dispatcher
