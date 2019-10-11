class Model::BinaryExpr
  attr_accessor :op, :left, :right

  def initialize ()
    @template = Template.make("templates/binaryExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
