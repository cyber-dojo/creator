# frozen_string_literal: true
require_relative 'creator_test_base'

class LanguageChooseTest < CreatorTestBase

  def self.id58_prefix
    'd73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |given the languages-start-points service is ready
  |when I request GET/group_language_choose
  |then the resulting page offers the names of all languages-start-points
  |ready for me to select one and create a group-exercise
  ) do
    get '/group_language_choose'
    assert status?(200), status
    html = last_response.body
    languages_start_points.display_names.each do |language_name|
      assert html =~ div_for(language_name), language_name
    end
  end

  # - - - - - - - - - - - - - - - - -

  test '19w', %w(
  |given the languages-start-points service is ready
  |when I request GET/kata_language_choose
  |then the resulting page offers the names of all languages-start-points
  |ready for me to select one and create an individual exercise
  ) do
    get '/kata_language_choose'
    assert status?(200), status
    html = last_response.body
    languages_start_points.display_names.each do |language_name|
      assert html =~ div_for(language_name), language_name
    end
  end

  private

  def div_for(display_name)
    # eg cater for "C++ (clang++), GoogleMock"
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
