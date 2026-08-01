$stdout.sync = true
$stderr.sync = true

require_relative '../app'
require_relative '../externals'
externals = CreatorClient::Externals.new
run CreatorClient::App.new(externals)
