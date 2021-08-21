require_relative 'creator_test_base'

class ChooseLanguageTest < CreatorTestBase

  def self.id58_prefix
    :D73
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/choose_ltf
  |offers all languages-start-points names
  ) do
    get '/choose_ltf'
    assert status?(200), status
    html = last_response.body
    languages_start_points.names.each do |name|
      assert html =~ display_name_div(name), name
    end
  end

end
