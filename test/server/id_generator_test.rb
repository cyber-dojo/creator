# frozen_string_literal: true
require_relative 'creator_test_base'
require_src 'id_generator'
require 'fileutils'
require 'tmpdir'

class IdGeneratorTest < CreatorTestBase

  def self.id58_prefix
    :A6D
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest a62:
  %w( the alphabet has 58 characters
  ) do
    assert_equal 58, alphabet.size
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest a63:
  %w( group ids are spread across the entire id alphabet
  ) do
    counted = {}
    until counted.size === alphabet.size do
      id_generator.group_id.chars.each do |letter|
        counted[letter] = true
      end
    end
    assert_equal alphabet.chars.sort, counted.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest a64:
  %w( kata ids are spead across the entire id alphabet
  ) do
    counted = {}
    until counted.size === alphabet.size do
      id_generator.kata_id.chars.each do |letter|
        counted[letter] = true
      end
    end
    assert_equal alphabet.chars.sort, counted.keys.sort
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest a65:
  %w( every letter of the alphabet can be used as part of a dir-name
  ) do
    diagnostic = 'forward slash is the dir separator'
    refute alphabet.include?('/'), diagnostic
    diagnostic = 'dot is a dir navigator'
    refute alphabet.include?('.'), diagnostic
    diagnostic = 'single quote to protect all other letters'
    refute alphabet.include?("'"), diagnostic
    alphabet.chars.each do |letter|
      path = Dir.mktmpdir("/tmp/#{letter}")
      FileUtils.mkdir_p(path)
      at_exit { FileUtils.remove_entry(path) }
    end
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest b13:
  %w( a created group-id does not exist before creation, does after
  ) do
    stub_rng(id = 'sD92wM')
    refute group_exists?(id), id
    assert_equal id, id_generator.group_id
    assert group_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest c13:
  %w( a created kata-id does not exist before creation, does after
  ) do
    stub_rng(id = '7w3RPx')
    refute kata_exists?(id), id
    assert_equal id, id_generator.kata_id
    assert kata_exists?(id), id
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest d13:
  %w( the id 999999 is reserved for a kata id when the saver is offline
  ) do
    id = 'eF762A'
    stub_rng(saver_offline_id+id)
    assert_equal id, id_generator.kata_id
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest e13: %w(
  |kata-id generation tries 42 times
  |and then gives up and returns nil
  |and you either have the worst random-number generator ever
  |or you are the unluckiest person ever
  ) do
    stub_rng(saver_offline_id*42)
    assert_nil id_generator.kata_id
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest f13: %w(
  |group-id generation tries 42 times
  |and then gives up and returns nil
  |and you either have the worst random-number generator ever
  |or you are the unluckiest person ever
  ) do
    stub_rng(saver_offline_id*42)
    assert_nil id_generator.group_id
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest f68:
  %w( id?(s) true examples
  ) do
    assert id?('012AaE')
    assert id?('345BbC')
    assert id?('678HhJ')
    assert id?('999PpQ')
    assert id?('263VvW')
  end

  # - - - - - - - - - - - - - - - - - - -

  qtest f69: 
  %w( id?(s) false examples
  ) do
    refute id?(42)
    refute id?(nil)
    refute id?({})
    refute id?([])
    refute id?(25)
    refute id?('I'), :India_uppercase_is_excluded
    refute id?('i'), :india_lowercase_is_excluded
    refute id?('O'), :Oscar_uppercase_is_excluded
    refute id?('o'), :oscar_lowercase_is_excluded
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

  def id_generator
    IdGenerator.new(externals)
  end

end
