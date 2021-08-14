require_relative 'creator_test_base'

class ProbeTest < CreatorTestBase

  def self.id58_prefix
    :a87
  end

  # - - - - - - - - - - - - - - - - -

  qtest d15: %w( its alive ) do
    assert true?(creator.alive?)
  end

  qtest d16: %w( its ready ) do
    assert true?(creator.ready?)
  end

end
