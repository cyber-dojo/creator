# frozen_string_literal: true
require_relative 'creator_test_base'

class ShaTest < CreatorTestBase

  def self.id58_prefix
    :de3
  end

  # - - - - - - - - - - - - - - - - -

  qtest p23: %w( sha is 40-char git commit sha ) do
    sha = externals.creator.sha
    assert git_sha?(sha), sha
  end

  private

  def git_sha?(s)
    s.is_a?(String) &&
      s.size === 40 &&
        s.each_char.all?{ |ch| is_lo_hex?(ch) }
  end

  def is_lo_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
