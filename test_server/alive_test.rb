require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.hex_prefix
    '198'
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( its alive ) do
    assert creator.alive?
  end

end
