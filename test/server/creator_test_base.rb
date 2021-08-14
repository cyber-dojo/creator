require_relative '../id58_test_base'
require_source 'app'
require_source 'externals'
require 'cgi'
require 'json'
require 'ostruct'

class CreatorTestBase < Id58TestBase

  include Rack::Test::Methods # [1]

  def app # [1]
    App.new(externals)
  end

  def externals
    @externals ||= Externals.new
  end

  # - - - - - - - - - - - - - - - -

  def assert_get_200_json(path, args={}, &block)
    stdout,stderr = capture_io {
      get path_with_args(path,args)
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :sdout
    block.call(json_response)
  end

  def assert_get_200_html(path, args={})
    stdout,stderr = capture_io {
      get path_with_args(path,args)
    }
    assert status?(200), status
    assert html_content?, content_type
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :sdout
  end

  def path_with_args(path, args)
    route = '/' + path
    unless args.empty?
      route += '?' + args.map{|name,value|
        "#{name.to_s}=#{CGI::escape(value)}"
      }.join('&')
    end
    route
  end

  # - - - - - - - - - - - - - - - -

  def assert_post_200_json(path, args, &block)
    stdout,stderr = capture_io {
      json_post '/'+path, args
    }
    assert status?(200), status
    assert json_content?, content_type
    assert_equal '', stderr, :stderr
    assert_equal '', stdout, :stdout
    block.call(json_response)
  end

  # - - - - - - - - - - - - - - - -

  def any_custom_start_points_display_name
    custom_start_points.display_names.sample
  end

  def any_exercises_start_points_display_name
    exercises_start_points.display_names.sample
  end

  def any_languages_start_points_display_name
    languages_start_points.display_names.sample
  end

  # - - - - - - - - - - - - - - - -

  def json_post(path, data)
    post path, data.to_json, JSON_REQUEST_HEADERS
  end

  def json_response
    @json_response ||= JSON.parse(last_response.body)
  end

  JSON_REQUEST_HEADERS = {
    'CONTENT_TYPE' => 'application/json', # sent request
    'HTTP_ACCEPT' => 'application/json'   # received response
  }

  private

  def custom_start_points
    externals.custom_start_points
  end

  def exercises_start_points
    externals.exercises_start_points
  end

  def languages_start_points
    externals.languages_start_points
  end

  def saver
    externals.saver
  end

  # - - - - - - - - - - - - - - -

  def status?(expected)
    status === expected
  end

  def status
    last_response.status
  end

  # - - - - - - - - - - - - - - -

  def html_content?
    content_type === 'text/html;charset=utf-8'
  end

  def css_content?
    content_type === 'text/css; charset=utf-8'
  end

  def json_content?
    content_type === 'application/json'
  end

  def js_content?
    content_type === 'application/javascript'
  end

  def content_type
    last_response.headers['Content-Type']
  end

  # - - - - - - - - - - - - - - -

  def escape_html(text)
    Rack::Utils.escape_html(text)
  end

  # - - - - - - - - - - - - - - -

  def group_exists?(id)
    saver.group_exists?(id)
  end

  def group_manifest(id)
    saver.group_manifest(id)
  end

  # - - - - - - - - - - - - - - -

  def kata_exists?(id)
    saver.kata_exists?(id)
  end

  def kata_manifest(id)
    saver.kata_manifest(id)
  end

  def kata_event(id, index)
    saver.kata_event(id, index)
  end

  # - - - - - - - - - - - - - - -

  def display_name_div(display_name)
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
