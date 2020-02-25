# frozen_string_literal: true

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def ready?
    services = []
    services << @externals.creator
    services << @externals.custom_start_points
    services << @externals.saver
    services.all?{ |service| service.ready? }
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def create_custom_group(display_name)
    @externals.creator.create_custom_group(display_name)
  end

  def create_custom_kata(display_name)
    @externals.creator.create_custom_kata(display_name)
  end

end
