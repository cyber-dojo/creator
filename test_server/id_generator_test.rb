require_relative 'creator_test_base'
require_relative '../id_generator'
require 'fileutils'
require 'tmpdir'

class IdGeneratorTest < CreatorTestBase

  def self.hex_prefix
    'A6D'
  end

  # - - - - - - - - - - - - - - - - - - -

  test '062', %w( alphabet has 58 characters ) do
    assert_equal 58, alphabet.size
  end

  # - - - - - - - - - - - - - - - - - - -

  test '063', %w( entire alphabet is used in group ids ) do
    id_generator = IdGenerator.new(externals)
    counts = {}
    until counts.size === 58 do
      id_generator.group_id.each_char do |ch|
        counts[ch] = true
      end
    end
    assert_equal alphabet.chars.sort, counts.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - -

  test '064', %w( entire alphabet is used in kata ids ) do
    id_generator = IdGenerator.new(externals)
    counts = {}
    until counts.size === 58 do
      id_generator.kata_id.each_char do |ch|
        counts[ch] = true
      end
    end
    assert_equal alphabet.chars.sort, counts.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - -

  test '065', %w(
  every letter of the alphabet can be used as part of a dir-name
  ) do
    diagnostic = 'forward slash is the dir separator'
    refute alphabet.include?('/'), diagnostic
    diagnostic = 'dot is a dir navigator'
    refute alphabet.include?('.'), diagnostic
    diagnostic = 'single quote to protect all other letters'
    refute alphabet.include?("'"), diagnostic
    alphabet.each_char do |letter|
      path = Dir.mktmpdir("/tmp/#{letter}")
      FileUtils.mkdir_p(path)
      at_exit { FileUtils.remove_entry(path) }
    end
  end

  # - - - - - - - - - - - - - - - - - - -

  test '13b', %w(
  group-id does not exist in saver before generation, does after
  ) do
    id =  'sD92wM'
    id_generator = stubbed_id_generator(id)
    refute group_exists?(id), id
    assert_equal id, id_generator.group_id
    assert group_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - - - -

  test '13c', %w(
  kata-id does not exist in saver before generation, does after
  ) do
    id =  '7w3RPx'
    id_generator = stubbed_id_generator(id)
    refute kata_exists?(id), id
    assert_equal id, id_generator.kata_id
    assert kata_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - - - -

  test '13d', %w(
  id 999999 is reserved for a kata id when saver is offline
  ) do
    id = 'eF762A'
    id_generator = stubbed_id_generator(saver_offline_id+id)
    assert_equal id, id_generator.kata_id
  end

  # - - - - - - - - - - - - - - - - - - -

  test '13e', %w(
  kata-id generation tries 42 times and then gives up and returns nil
  and you either have the worst random-number generator ever
  or you are the unluckiest person ever
  ) do
    id_generator = stubbed_id_generator(saver_offline_id*42)
    assert_nil id_generator.kata_id
  end

  # - - - - - - - - - - - - - - - - - - -

  test '13f', %w(
  group-id generation tries 42 times and then gives up and returns nil
  and you either have the worst random-number generator ever
  or you are the unluckiest person ever
  ) do
    id_generator = stubbed_id_generator(saver_offline_id*42)
    assert_nil id_generator.group_id
  end

  # - - - - - - - - - - - - - - - - - - -

  test '068', %w(
  id?(s) true examples
  ) do
    assert id?('012AaE')
    assert id?('345BbC')
    assert id?('678HhJ')
    assert id?('999PpQ')
    assert id?('263VvW')
  end

  # - - - - - - - - - - - - - - - - - - -

  test '069', %w(
  id?(s) false examples
  ) do
    refute id?(42)
    refute id?(nil)
    refute id?({})
    refute id?([])
    refute id?(25)
    refute id?('I'), :India
    refute id?('i'), :india
    refute id?('O'), :Oscar
    refute id?('o'), :oscar
    refute id?('12345'), :not_length_6
    refute id?('1234567'), :not_length_6
  end

  private

  def alphabet
    IdGenerator::ALPHABET
  end

  def saver_offline_id
    IdGenerator::SAVER_OFFLINE_ID
  end

  def id?(s)
    IdGenerator::id?(s)
  end

  def stubbed_id_generator(stub)
    externals.instance_eval { @random = RandomStub.new(stub) }
    IdGenerator.new(externals)
  end

  class RandomStub
    def initialize(letters)
      alphabet = IdGenerator::ALPHABET
      @indexes = letters.each_char.map{ |ch| alphabet.index(ch) }
      @n = 0
    end
    def rand(size)
      index = @indexes[@n]
      @n += 1
      index
    end
  end

end
