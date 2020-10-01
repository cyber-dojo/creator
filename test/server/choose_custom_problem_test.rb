# frozen_string_literal: true
require_relative 'creator_test_base'

class ChooseCustomProblemTest < CreatorTestBase

  def self.id58_prefix
    'A73'
  end

  # - - - - - - - - - - - - - - - - -

  test '18w', %w(
  |GET/choose_custom_problem
  |offers all custom_start_points display_names
  ) do
    get '/choose_custom_problem'
    assert status?(200), status
    html = last_response.body
    custom_start_points.display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  private

  def div_for(display_name)
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
