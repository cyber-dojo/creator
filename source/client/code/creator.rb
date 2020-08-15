# frozen_string_literal: true

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def ready?
    creator.ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_names, _options=default_options)
    creator.group_create_custom(display_names)
  end

  def kata_create_custom(display_name, _options=default_options)
    creator.kata_create_custom(display_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create(exercise_name, languages_names, _options=default_options)
    creator.group_create(exercise_name, languages_names)
  end

  def kata_create(exercise_name, language_name, _options=default_options)
    creator.kata_create(exercise_name, language_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_group_create_custom(display_name)
    creator.deprecated_group_create_custom(display_name)
  end

  def deprecated_kata_create_custom(display_name)
    creator.deprecated_kata_create_custom(display_name)
  end

  private

  def default_options
    { "line_numbers":true,
      "syntax_highlight":false,
      "predict_colour":false
    }
  end

  def creator
    @externals.creator
  end

end
