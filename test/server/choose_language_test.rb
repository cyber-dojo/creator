# frozen_string_literal: true
require_relative 'creator_test_base'

class ChooseLanguageTest < CreatorTestBase

  def self.id58_prefix
    :D73
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/choose_ltf
  |offers all languages-start-points display_names
  ) do
    get '/choose_ltf'
    assert status?(200), status
    html = last_response.body
    languages_start_points.display_names.each do |language_name|
      assert html =~ display_name_div(language_name), language_name
    end
  end

end
