require_relative 'creator_test_base'
require_relative 'custom_start_points'

class CreatorTest < CreatorTestBase

  def self.hex_prefix
    '26F'
  end

  # - - - - - - - - - - - - - - - - -

  test '191', %w( creator service sha is 40-char git commit sha ) do
    sha = creator.sha
    assert is_sha_like?(sha), sha
  end

  # - - - - - - - - - - - - - - - - -

  test '93b',
  %w( creator service is alive ) do
    assert creator.alive?
  end

  test '602',
  %w( creator service is ready ) do
    assert creator.ready?
  end

  # - - - - - - - - - - - - - - - - -

  test '702',
  %w( create_group returns id of group which exists ) do
    id = creator.create_group(manifest)
    assert group_exists?(id), id
  end

  test '703',
  %w( create_kata returns id of kata which exists ) do
    id = creator.create_kata(manifest)
    assert kata_exists?(id), id
  end

  private
  
  def is_sha_like?(s)
    s.size === 40 && s.each_char.all?{|ch| is_hex?(ch) }
  end

  def is_hex?(ch)
    '0123456789abcdef'.include?(ch)
  end

end
