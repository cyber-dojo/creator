# frozen_string_literal: true
require_relative 'creator_test_base'

class ShaTest < CreatorTestBase

  def self.id58_prefix
    'de3'
  end

  # - - - - - - - - - - - - - - - - -

  test 'p23', %w( GET /sha returns JSON'd 40-char git commit sha ) do
    get '/sha'
    assert last_response.ok?
    sha = json_response['sha']
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
