# frozen_string_literal: true
require_relative 'http_json_args'
require_relative 'json_hash/http/requester'
require_relative 'json_hash/generator'

class RackDispatcher

  def initialize(creator, request_class)
    @creator = creator
    @request_class = request_class
  end

  def call(env)
    request = @request_class.new(env)
    body = request.body.read
    path = request.path_info
    params = request.params

    puts "RackDispatcher:body:#{body}:"
    puts "RackDispatcher:path:#{path}:"
    puts "RackDispatcher:params:#{params}:"

    #name,args = HttpJsonArgs.new(body).get(path, params)
    name,args = HttpJsonArgs::get(body, path, params)
    result = @creator.public_send(name, *args)
    json_response(200, { name => result })
  rescue JsonHash::Http::Requester::Error => error
    json_response(400, diagnostic(path, body, error))
  rescue Exception => error
    json_response(500, diagnostic(path, body, error))
  end

  private

  def json_response(status, json)
    if status === 200
      body = JsonHash::Generator::fast(json)
    else
      body = JsonHash::Generator::pretty(json)
      $stderr.puts(body)
    end
    [ status,
      { 'Content-Type' => 'application/json' },
      [ body ]
    ]
  end

  # - - - - - - - - - - - - - - - -

  def diagnostic(path, body, error)
    { 'exception' => {
        'path' => path,
        'body' => body,
        'class' => 'CreatorService',
        'message' => error.message,
        'backtrace' => error.backtrace
      }
    }
  end

end
