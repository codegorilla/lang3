require 'erb'

class Template

  def initialize (filename)
    @erb = ERB.new(File.read(filename), nil, trim_mode=">", eoutvar='_sub01')
    @attr = {}
  end

  def self.make (filename)
    Template.new(filename)
  end

  def add (name, value)
    @attr[name] = value
    self
  end

  def render ()
    @erb.result(binding)
  end

end
