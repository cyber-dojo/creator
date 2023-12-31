# frozen_string_literal: true
$stdout.sync = true
$stderr.sync = true

require_relative '../app'
require_relative '../externals'
externals = Externals.new
run App.new(externals)
