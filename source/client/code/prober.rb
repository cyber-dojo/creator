# frozen_string_literal: true

class Prober

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -

  def alive?(_args=nil)
    creator.alive?
  end

  def ready?(_args=nil)
    creator.ready?
  end

  def sha(_args=nil)
    creator.sha
  end

  private

  def creator
    @externals.creator
  end

end
