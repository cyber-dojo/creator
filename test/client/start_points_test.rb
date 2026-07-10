require_relative 'creator_test_base'

class StartPointsTest < CreatorTestBase

  # - - - - - - - - - - - - - - - - -

  qtest StPt20: %w[
    |custom_start_points names is a non-empty list of display names
  ] do
    names = custom_start_points.names
    assert names.is_a?(Array), names.class
    refute_empty names, names
  end

  # - - - - - - - - - - - - - - - - -

  qtest StPt21: %w[
    |languages_start_points names is a non-empty list of display names
  ] do
    names = languages_start_points.names
    assert names.is_a?(Array), names.class
    refute_empty names, names
  end

end
