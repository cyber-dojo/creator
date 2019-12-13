require_relative 'creator_test_base'

class ReadyTest < CreatorTestBase

  def self.hex_prefix
    '0B2'
  end

  # - - - - - - - - - - - - - - - - -

  test '602',
  %w( creator service is ready ) do
    assert creator.ready?
  end

end
