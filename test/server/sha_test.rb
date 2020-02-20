# frozen_string_literal: true
require_relative 'creator_test_base'

class ShaTest < CreatorTestBase

  def self.id58_prefix
    :de3
  end

  # - - - - - - - - - - - - - - - - -

  qtest p23: %w(
  GET /sha returns JSON'd 40-char git commit sha
  ) do
    get '/sha'
    assert_status(200)
    sha = json_response['sha']
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
