# frozen_string_literal: true
require_relative 'http_adapter'
require_relative 'custom_start_points'
require_relative 'creator'
require 'json'

class Demo

  def call(_env)
    inner_call
    [ 200, content_text_html, [ @html ] ]
  rescue => error
    [ 400, content_text_html, [ [error.message] + [error.backtrace] ] ]
  end

  def inner_call
    @html = ''
    @html += '<h1>GET /sha</h1>'
    @html += pre(sha_snippet)
    sha
    @html += '<h1>GET /alive?</h1>'
    @html += pre(alive_snippet)
    alive?
    @html += '<h1>GET /ready?</h1>'
    @html += pre(ready_snippet)
    ready?
    #@html += '<h1>GET /run_cyber_dojo_sh</h1>'
    #@html += pre(run_cyber_dojo_sh_snippet)
    #run_cyber_dojo_sh('cyberdojofoundation/gcc_assert')
    #run_cyber_dojo_sh('BAD/image_name')
  end

  private

  def sha
    result,duration = timed { creator.sha }
    @html += boxed_pre(duration, result)
  end

  def sha_snippet
    [
      'sha = creator.sha',
      'html = green(JSON.pretty_unparse(sha))'
    ].join("\n")
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def alive?
    result,duration = timed { creator.alive? }
    @html += boxed_pre(duration, result)
  end

  def alive_snippet
    [
      'alive = creator.alive?',
      'html = green(JSON.pretty_unparse(alive))'
    ].join("\n")
  end

  # - - - - - - - - - - - - - - - - - - - - -

  def ready?
    result,duration = timed { creator.ready? }
    @html += boxed_pre(duration, result)
  end

  def ready_snippet
    [
      'ready = creator.ready?',
      'html = green(JSON.pretty_unparse(ready))'
    ].join("\n")
  end

  # - - - - - - - - - - - - - - - - - - - - -

=begin
  def run_cyber_dojo_sh(image_name)
    args  = [ image_name, '729z65', gcc_assert_files, 10 ]
    _,duration = timed {
      begin
        @result = runner.run_cyber_dojo_sh(*args)
        @raised = false
      rescue => error # ServiceError better RunnerError
        @result = JSON.parse(error.message)
        @raised = true
      end
    }
    css_colour = @raised ? 'LightGray' : 'LightGreen'
    @html += boxed_pre(duration, @result, css_colour)
  end

  def run_cyber_dojo_sh_snippet
    [
      'begin',
      '  result = runner.run_cyber_dojo_sh(...)',
      '  html = green(JSON.pretty_unparse(result))',
      'rescue => error',
      '  json = JSON.parse(error.message)',
      '  html = gray(JSON.pretty_unparse(json))',
      'end'
    ].join("\n")
  end
=end

  # - - - - - - - - - - - - - - - - - - - - -

  def creator
    Creator.new(http_adapter)
  end

  def custom_start_points
    CustomStartPoints.new(http_adapter)
  end

  def http_adapter
    HttpAdapter.new
  end

  def timed
    started = Time.now
    result = yield
    finished = Time.now
    duration = '%.2f' % (finished - started)
    [result, duration]
  end

=begin
  def gcc_assert_files
    manifest = languages_start_points.manifest('C (gcc), assert')
    manifest['visible_files'].map do |filename,file|
      [ filename, file['content'] ]
    end.to_h
  end
=end

  def pre(fragment)
    "<pre style='margin-left:30px'>#{fragment}</pre>"
  end

  def boxed_pre(duration, result, css_colour = 'LightGreen')
    border = 'border: 1px solid black;'
    padding = 'padding: 5px;'
    margin = 'margin-left: 30px; margin-right: 30px;'
    background = "background: #{css_colour};"
    whitespace = "white-space: pre-wrap;"
    font = 'font-size:8pt;'
    "<pre style='#{whitespace}#{margin}#{border}#{padding}#{background}#{font}'>" +
      "#{duration}s\n" +
      "#{JSON.pretty_unparse(result)}" +
    '</pre>'
  end

  def content_text_html
    { 'Content-Type' => 'text/html' }
  end

end
