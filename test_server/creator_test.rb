require_relative 'creator_test_base'
require_relative 'custom_start_points'

class CreatorTest < CreatorTestBase

  def self.hex_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( create_group ) do
    id = creator.create_group(manifest)
    assert group_exists?(id), id
  end

  test '703',
  %w( create_kata ) do
    id = creator.create_kata(manifest)
    assert kata_exists?(id), id
  end

end
