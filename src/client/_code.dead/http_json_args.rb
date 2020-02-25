# frozen_string_literal: true
require_relative 'services/http_json/error'
require_relative 'json_adapter'

class HttpJsonArgs

  def initialize(body)
    @args = JsonAdapter::parse(body)
    unless @args.is_a?(Hash)
      raise request_error('body is not JSON Hash')
    end
  rescue JsonAdapter::ParseError
    raise request_error('body is not JSON')
  end

  # - - - - - - - - - - - - - - - -

  def get(path)
    case path
    when '/ready' then ['ready?',[]]
    else
      raise request_error('unknown path')
    end
  end

  private

  def missing(arg_name)
    request_error("#{arg_name} is missing")
  end

  # - - - - - - - - - - - - - - - -

  def request_error(text)
    # Exception messages use the words 'body' and 'path'
    # to match RackDispatcher's exception keys.
    HttpJson::Error.new(text)
  end

end
