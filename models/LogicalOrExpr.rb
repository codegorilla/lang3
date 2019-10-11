class Model::LogicalOrExpr
  attr_accessor :left, :right

  def initialize ()
    @template = Template.make("templates/logicalOrExpr.c.erb")
  end

  def render ()
    @template.render(binding)
  end

end
