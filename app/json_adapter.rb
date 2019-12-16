require 'json'

module JsonAdapter

  def fast_json(obj)
    JSON.fast_generate(obj)
  end

  def pretty_json(obj)
    JSON.pretty_generate(obj)
  end

end
