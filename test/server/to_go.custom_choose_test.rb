# frozen_string_literal: true
require_relative 'creator_test_base'

class CustomChooseTest < CreatorTestBase

  def self.id58_prefix
    :a73
  end

  # - - - - - - - - - - - - - - - - -

  qtest w18: %w(
  |GET/group_custom_choose
  |offers all display_names
  |ready to create a group
  |when custom_start_points is online
  ) do
    get '/group_custom_choose'
    assert status?(200), status
    html = last_response.body
    custom_start_points.display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  # - - - - - - - - - - - - - - - - -

  qtest w19: %w(
  |GET/kata_custom_choose
  |offers all display_names
  |ready to create a kata
  |when custom_start_points is online
  ) do
    get '/kata_custom_choose'
    assert status?(200), status
    html = last_response.body
    custom_start_points.display_names.each do |display_name|
      assert html =~ div_for(display_name), display_name
    end
  end

  private

  def div_for(display_name)
    # eg cater for "C++ Countdown, Round 1"
    name = Regexp.quote(escape_html(display_name))
    /<div class="display-name"\s*data-name=".*"\s*data-index=".*">\s*#{name}\s*<\/div>/
  end

end
