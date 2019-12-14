require_relative 'creator_test_base'
require_relative 'custom_start_points'

class CreatorTest < CreatorTestBase

  def self.hex_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '191', %w( /sha is 40-char git commit sha ) do
    sha = creator.sha
    assert git_sha?(sha), sha
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( its alive ) do
    assert creator.alive?
  end

  test '602',
  %w( its ready ) do
    assert creator.ready?
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( /create_group returns the id of a newly created group ) do
    id = creator.create_group(any_manifest)
    assert group_exists?(id), id
  end

  test '703',
  %w( /create_kata returns the id of a newly created kata ) do
    id = creator.create_kata(any_manifest)
    assert kata_exists?(id), id
  end

  private

  def git_sha?(s)
    s.size === 40 && s.each_char.all?{ |ch| is_hex?(ch) }
  end

  def is_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
