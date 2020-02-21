# frozen_string_literal: true
require_relative 'creator_test_base'
require_src 'saver_asserter'
require 'json'

class SaverAsserterTest < CreatorTestBase

  def self.id58_prefix
    :A27
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '967', %w(
  when all commands succeed
  then saver_assert.batch(commands) succeeds
  and returns an array of the results
  ) do
    results = saver_asserter.batch(
      ['create','34/45/56'],
      ['exists?','34/45/56'],
      ['write','34/45/56/manifest.json','{"name":"bob"}'],
      ['read','34/45/56/manifest.json']
    )
    assert_equal [true,true,true,'{"name":"bob"}'], results
  end

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  test '968', %w(
  when any command fails
  saver_assert.batch(commands) raises a Saver::Error
  with a json error.message
  ) do
    error = assert_raises(RuntimeError) {
      saver_asserter.batch(
        ['create','qw/jk/56'],
        ['exists?','qw/jk/56'],
        ['read','qw/jk/56/manifest.json']
      )
    }
    actual = JSON.parse!(error.message)
    expected = [
      { 'name' => 'create',  'arg[0]' => 'qw/jk/56', 'result' => true },
      { 'name' => 'exists?', 'arg[0]' => 'qw/jk/56', 'result' => true },
      { 'name' => 'read',    'arg[0]' => 'qw/jk/56/manifest.json', 'result' => false }
    ]
    assert_equal expected, actual
  end

  private

  def saver_asserter
    SaverAsserter.new(externals.saver)
  end

end
