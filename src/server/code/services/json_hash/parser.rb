# frozen_string_literal: true
require 'json'

module JsonHash
  module Parser

    def self.parse(s)
      if s === ''
        {}
      else
        JSON.parse!(s)
      end
    end

    Error = JSON::ParserError

  end
end
