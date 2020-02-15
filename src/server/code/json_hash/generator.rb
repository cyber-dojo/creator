# frozen_string_literal: true
require 'json'

module JsonHash
  module Generator

    def self.fast(obj)
      JSON.fast_generate(obj)
    end

    def self.pretty(obj)
      JSON.pretty_generate(obj)
    end

  end
end
