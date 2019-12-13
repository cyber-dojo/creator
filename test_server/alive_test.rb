require_relative 'creator_test_base'

class AliveTest < CreatorTestBase

  def self.hex_prefix
    '198'
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( creator service is alive ) do
    assert creator.alive?
  end

end
