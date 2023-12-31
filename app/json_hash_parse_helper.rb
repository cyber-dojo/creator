# frozen_string_literal: true

module JsonHashParseHelper
  def json_hash_parse(body)
    json = (body === '') ? {} : JSON.parse!(body)
    unless json.instance_of?(Hash)
      raise 'body is not JSON Hash'
    end

    json
  rescue JSON::ParserError
    raise 'body is not JSON'
  end
end
