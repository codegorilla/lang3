class Model::BinaryExpr
  attr_accessor :op, :left, :right

  def initialize ()
  end

  def render ()
    @template = Template.make("templates/binaryExpr.c.erb")
    @template.render(binding)
  end

end
