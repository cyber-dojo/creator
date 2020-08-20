# frozen_string_literal: true
require_relative 'creator_test_base'

class JsAssetsTest < CreatorTestBase

  def self.id58_prefix
    'Q4p'
  end

  # - - - - - - - - - - - - - - - - -

  test '3Je', %w(
  |GET /assets/app.js is served
  ) do
    get '/assets/app.js'
    assert status?(200), status
    assert js_content?, content_type
  end

end
