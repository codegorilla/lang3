require 'erb'

class Template

  def initialize (filename, level=0)
    @erb = ERB.new(File.read(filename), nil, trim_mode=">", eoutvar='_sub01')
    @attr = {}
    @indent = level
  end

  def self.make (filename, level=0)
    Template.new(filename, level)
  end

  def add (name, value)
    @attr[name] = value
    self
  end

  # def indent ()
  #   s = ""
  #   @indent.times do
  #     s += "  "
  #   end
  #   s
  # end

  def render (bindg=nil)
    if bindg != nil
      @erb.result(bindg)
    else
      @erb.result(binding)
    end
  end

end
