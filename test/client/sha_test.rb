# frozen_string_literal: true

require_relative 'creator_test_base'

class ShaTest < CreatorTestBase
  def self.id58_prefix
    :de3
  end

  # - - - - - - - - - - - - - - - - -

  qtest p23: %w[sha is 40-char git commit sha] do
    sha = creator.sha
    assert git_sha?(sha), sha
  end

  private

  def git_sha?(str)
    str.is_a?(String) &&
      str.size === 40 &&
      str.each_char.all? { |ch| lo_hex?(ch) }
  end

  def lo_hex?(char)
    '0123456789abcdef'.include?(char)
  end
end
