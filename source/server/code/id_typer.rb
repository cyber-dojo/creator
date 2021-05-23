# frozen_string_literal: true

class IdTyper

  def initialize(externals)
    @externals = externals
  end

  def id_type(args)
    id = args['id']
    if saver.group_exists?(id)
      'group'
    elsif saver.kata_exists?(id)
      'single'
    else
      nil
    end
  end

  private

  def saver
    @externals.saver
  end

end
