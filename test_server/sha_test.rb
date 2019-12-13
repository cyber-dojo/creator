require_relative 'creator_test_base'

class ShaTest < CreatorTestBase

  def self.hex_prefix
    'FB3'
  end

  # - - - - - - - - - - - - - - - - -

  test '191', %w( creator service sha is 40-char commit sha of image ) do
    sha = creator.sha
    assert is_sha_like?(sha), sha
  end

  private

  def is_sha_like?(s)
    s.size === 40 && s.each_char.all?{|ch| is_hex?(ch) }
  end

  def is_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end
  
end
