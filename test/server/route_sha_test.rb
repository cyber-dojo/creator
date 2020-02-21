# frozen_string_literal: true
require_relative 'creator_test_base'

class RouteShaTest < CreatorTestBase

  def self.id58_prefix
    :de3
  end

  # - - - - - - - - - - - - - - - - -

  qtest p23: %w(
  |GET /sha
  |has status 200
  |returns the 40-char git commit sha used to create the image
  |and nothing else
  ) do
    assert_get_200(key='sha') do |jr|
      assert_equal [key], jr.keys, last_response.body
      sha = jr[key]
      assert git_sha?(sha), sha
    end
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
