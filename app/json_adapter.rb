require 'json'

module JsonAdapter

  def self.fast(obj)
    JSON.fast_generate(obj)
  end

  def self.pretty(obj)
    JSON.pretty_generate(obj)
  end

  def self.parse(s)
    if s === ''
      {}
    else
      JSON.parse!(s)
    end
  end

end
