# frozen_string_literal: true
require_relative 'services/json_hash/http/requester'
require_relative 'http_json_args'
require_relative 'json_hash'

class RackDispatcher

  def initialize(creator, request_class)
    @creator = creator
    @request_class = request_class
  end

  def call(env)
    request = @request_class.new(env)
    path = request.path_info
    body = request.body.read
    name,args = HttpJsonArgs.new(body).get(path)
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
      body = JsonHash::fast(json)
    else
      body = JsonHash::pretty(json)
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
