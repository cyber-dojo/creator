# frozen_string_literal: true
require 'json'

module JsonHash
  module Parse

    def self.fast(s)
      JSON.parse!(s)
    end

    Error = JSON::ParserError

  end
end
