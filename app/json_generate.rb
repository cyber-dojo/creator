require 'json'

module JsonGenerate

  def json_fast(obj)
    JSON.fast_generate(obj)
  end

  def json_pretty(obj)
    JSON.pretty_generate(obj)
  end

end
