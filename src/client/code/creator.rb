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

  def create_custom_group(display_name)
    @externals.creator.create_custom_group(display_name)
  end

  def create_custom_kata(display_name)
    @externals.creator.create_custom_kata(display_name)
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def deprecated_create_custom_group(display_name)
    @externals.creator.deprecated_create_custom_group(display_name)
  end

  def deprecated_create_custom_kata(display_name)
    @externals.creator.deprecated_create_custom_kata(display_name)
  end

end
