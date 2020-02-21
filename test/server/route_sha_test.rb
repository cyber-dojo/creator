# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteShaTest < CreatorTestBase

  def self.id58_prefix
    :de3
  end

  # - - - - - - - - - - - - - - - - -

  qtest p23: %w(
  GET /sha returns JSON'd 40-char git commit sha
  ) do
    sha = assert_get_200 '/sha'
    assert git_sha?(sha), sha
  end

  private

  def git_sha?(s)
    s.instance_of?(String) &&
      s.size === 40 &&
        s.chars.all?{ |ch| is_lo_hex?(ch) }
  end

  def is_lo_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
