require_relative 'creator_test_base'

class SingleTest < CreatorTestBase

  def self.id58_prefix
    :q8e
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/single is 200
  ) do
    get '/single'
    assert status?(200), status
  end

end
