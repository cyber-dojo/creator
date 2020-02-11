# frozen_string_literal: true

require_relative 'json_adapter'
require_relative 'services/saver'

class SaverAsserter

  def initialize(saver)
    @saver = saver
  end

  def batch(*commands)
    results = @saver.batch(commands)
    if results.any?(false)
      message = results.zip(commands).map do |result,(name,arg0)|
        saver_assert_info(name, arg0, result)
      end
      raise Saver::Error, JsonAdapter::pretty(message)
    end
    results
  end

  private

  def saver_assert_info(name, arg0, result)
    { 'name' => name, 'arg[0]' => arg0, 'result' => result }
  end

end
