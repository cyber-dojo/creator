require_relative 'creator_test_base'

class ProbeTest < CreatorTestBase

  # - - - - - - - - - - - - - - - - -

  qtest a87d15: %w[its alive] do
    assert true?(creator.alive?)
  end

  qtest a87d16: %w[its ready] do
    assert true?(creator.ready?)
  end
end
