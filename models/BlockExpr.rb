class Model::BlockExpr
  attr_accessor :elements

  def initialize ()
    @template = Template.make("templates/blockExpr.c.erb")
    @indent = 1
  end

  def indent ()
    s = ""
    @indent.times do
      s += "  "
    end
    s
  end

  def render ()
    @template.render(binding)
  end

end
