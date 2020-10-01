# frozen_string_literal: true
require_relative 'creator_test_base'

class ChooseLanguageTest < CreatorTestBase

  def self.id58_prefix
    'D73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/choose_ltf
  |offers all languages-start-points display_names
  ) do
    get '/choose_ltf'
    assert status?(200), status
    html = last_response.body
    languages_start_points.display_names.each do |language_name|
      assert html =~ div_for(language_name), language_name
    end
  end

  private

  def div_for(display_name)
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
