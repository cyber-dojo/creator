# frozen_string_literal: true

class Home

  def initialize(externals)
    @externals = externals
  end

  def id_type(args)
    id = args['id']
    if model.group_exists?(id)
      'group'
    elsif model.kata_exists?(id)
      'single'
    else
      nil
    end
  end

  private

  def model
    @externals.model
  end

end
