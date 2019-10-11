class Model::LogicalAndExpr
  attr_accessor :left, :right

  def initialize ()
    @template = Template.make("templates/logicalAndExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
