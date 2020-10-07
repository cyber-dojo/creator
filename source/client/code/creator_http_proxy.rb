# frozen_string_literal: true

class CreatorHttpProxy

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def alive?(_args)
    creator.alive?
  end

  def ready?(_args)
    creator.ready?
  end

  def sha(_args)
    creator.sha
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
