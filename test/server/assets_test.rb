require_relative 'creator_test_base'
require 'digest'

class AssetsTest < CreatorTestBase
  def self.id58_prefix
    'Q3p'
  end

  # - - - - - - - - - - - - - - - - -

  test '2Je', %w[
    |GET /assets/app.css is served
  ] do
    get '/assets/app.css'
    assert status?(200), status
    assert css_content?, content_type
  end

  # - - - - - - - - - - - - - - - - -

  test '3Je', %w[
    |GET /assets/app.js is served
  ] do
    get '/assets/app.js'
    assert status?(200), status
    assert js_content?, content_type
  end

  # - - - - - - - - - - - - - - - - -

  test '4Je', %w[
    |GET /assets/app.css is served with a long-lived immutable
    |Cache-Control header, so browsers do not re-pull it through
    |nginx's rate-limited /creator/ zone on every page navigation
  ] do
    get '/assets/app.css'
    assert status?(200), status
    assert_equal 'public, max-age=31536000, immutable',
                 last_response.headers['Cache-Control']
  end

  # - - - - - - - - - - - - - - - - -

  test '5Je', %w[
    |GET /assets/app.js is served with a long-lived immutable
    |Cache-Control header, for the same reason as 4Je
  ] do
    get '/assets/app.js'
    assert status?(200), status
    assert_equal 'public, max-age=31536000, immutable',
                 last_response.headers['Cache-Control']
  end

  # - - - - - - - - - - - - - - - - -

  test '6Je', %w[
    |the layout references each asset with a ?v=<content-hash>
    |token, so any change to an asset's content yields a new URL
    |that safely busts the immutable browser cache on the next deploy
  ] do
    get '/assets/app.css'
    css_digest = Digest::SHA256.hexdigest(last_response.body)[0, 8]
    get '/assets/app.js'
    js_digest = Digest::SHA256.hexdigest(last_response.body)[0, 8]
    get '/home'
    assert status?(200), status
    html = last_response.body
    assert html.include?("/creator/assets/app.css?v=#{css_digest}"), html
    assert html.include?("/creator/assets/app.js?v=#{js_digest}"), html
  end
end
