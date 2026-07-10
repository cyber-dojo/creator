require_relative 'creator_test_base'

class SaverTest < CreatorTestBase

  # Real seeded saver data: a full group and one of its member katas.
  # See bin/copy_in_saver_test_data.sh and test/data/full-group-FD6ryx.tgz
  GROUP_ID = 'FD6ryx'
  KATA_ID  = '3u6WT5'
  DISPLAY_NAME = 'Bash, bats'

  # - - - - - - - - - - - - - - - - -

  qtest Sv3r10: %w[
    |saver group_exists? is true for a seeded group
    |and group_manifest returns that group's manifest
  ] do
    assert true?(saver.group_exists?(GROUP_ID)), GROUP_ID
    manifest = saver.group_manifest(GROUP_ID)
    assert_equal DISPLAY_NAME, manifest['display_name'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  qtest Sv3r11: %w[
    |saver kata_exists? is true for a seeded kata
    |and kata_manifest returns that kata's manifest
  ] do
    assert true?(saver.kata_exists?(KATA_ID)), KATA_ID
    manifest = saver.kata_manifest(KATA_ID)
    assert_equal DISPLAY_NAME, manifest['display_name'], manifest
  end

  # - - - - - - - - - - - - - - - - -

  qtest Sv3r12: %w[
    |saver group_exists? and kata_exists? are false for an unknown id
  ] do
    assert_equal false, saver.group_exists?('000000'), :group_exists
    assert_equal false, saver.kata_exists?('000000'), :kata_exists
  end

end
