# frozen_string_literal: true
require 'json'

module JsonAdapter

  def self.fast(obj)
    JSON.fast_generate(obj)
  end

  def self.pretty(obj)
    JSON.pretty_generate(obj)
  end

  def self.parse(s)
    JSON.parse!(s)
  end

  ParseError = JSON::ParserError

end
