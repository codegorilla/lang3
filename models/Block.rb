class Model::Block
  attr_accessor :elements

  def initialize ()
    @indent = 0
  end

  def indent ()
    s = ""
    @indent.times do
      s += "  "
    end
    s
  end

  def render ()
    @template = Template.make("templates/block.c.erb")
    @template.render(binding)
  end

end
