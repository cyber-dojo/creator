# frozen_string_literal: true

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def ready?
    @externals.all_ready?
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def group_create_custom(display_names)
    @externals.creator.group_create_custom(display_names)
  end

  def kata_create_custom(display_name)
    @externals.creator.kata_create_custom(display_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_group_create_custom(display_name)
    @externals.creator.deprecated_group_create_custom(display_name)
  end

  def deprecated_kata_create_custom(display_name)
    @externals.creator.deprecated_kata_create_custom(display_name)
  end

end
