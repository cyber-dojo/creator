# frozen_string_literal: true

class Creator

  def initialize(externals)
    @externals = externals
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # identity

  def sha
    ENV['SHA']
  end

  # - - - - - - - - - - - - - - - - - - - - - -
  # k8s/curl probing

  def alive?
    true
  end

  def ready?
    services = []
    services << @externals.creator
    services.all?{ |service| service.ready? }
  end

end
