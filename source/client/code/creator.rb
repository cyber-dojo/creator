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

  def deprecated_group_create_custom(display_name)
    creator.deprecated_group_create_custom(display_name)
  end

  def deprecated_kata_create_custom(display_name)
    creator.deprecated_kata_create_custom(display_name)
  end

  private

  def creator
    @externals.creator
  end

end
